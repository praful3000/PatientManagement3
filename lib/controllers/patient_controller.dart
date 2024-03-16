import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_management/models/patient.dart';
import 'package:patient_management/models/patient_records.dart';
import 'package:patient_management/utils/base_url.dart';
import 'package:http/http.dart' as http;
import 'package:patient_management/utils/critical.dart';
import 'package:patient_management/utils/custom_snackbar.dart';
import 'package:patient_management/utils/shared_prefs.dart';
import 'package:image_picker/image_picker.dart';

class PatientController extends GetxController {
  bool patientLoading = false;
  List<Patient> allPatients = [];
  List<Patient> filteredPatients = [];

  List<Records> patientRecords = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController wardController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController conditionController = TextEditingController();

  TextEditingController bpController = TextEditingController();
  TextEditingController rrController = TextEditingController();
  TextEditingController boController = TextEditingController();
  TextEditingController hrController = TextEditingController();

  String selectedDate = DateTime.now().toString().split(' ')[0];

  List<String> wards = ['GENERAL', 'PRE-OP', 'POST-OP', 'EMERGENCY', 'OP'];
  List<String> conditions = ['Select Condition', 'Normal', 'Critical'];
  List<String> genders = ['M', 'F', 'O'];

  String ward = 'GENERAL';
  String condition = 'Normal';
  String gender = 'M';

  File? imageFile;

  String searchText = '';
  String searchCondition = 'Select Condition';

  pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;

    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAllPatients();
  }

  searchPatients(String val, String condition) {
    if (val.isEmpty && (condition.isEmpty || condition == 'Choose Condition')) {
      filteredPatients = allPatients;
    } else if (val.isNotEmpty &&
        (condition.isEmpty || condition == 'Choose Condition')) {
      filteredPatients = allPatients
          .where((patient) =>
              (patient.name!.toLowerCase().contains(val.toLowerCase())))
          .toList();
    } else if (val.isEmpty &&
        (condition.isNotEmpty && condition != 'Choose Condition')) {
      filteredPatients = allPatients.where((patient) {
        if (condition == 'Critical') {
          return isCritical(patient.records!);
        }
        return !isCritical(patient.records!);
      }).toList();
    } else {
      filteredPatients = allPatients
          .where((patient) =>
              (patient.name!.toLowerCase().contains(val.toLowerCase())) &&
              (condition == 'Critical'
                  ? isCritical(patient.records!)
                  : !isCritical(patient.records!)))
          .toList();
    }
    update();
  }

  fetchAllPatients() async {
    patientLoading = true;
    update();

    var usr = await SharedPrefs().getUser();
    var token = json.decode(usr)['token'];

    var response = await http.get(
      Uri.parse('${baseUrl}patients'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    var res = await json.decode(response.body);

    if (res['success']) {
      allPatients = AllPatients.fromJson(res).data!.patient!;
      filteredPatients = AllPatients.fromJson(res).data!.patient!;

      for (var i = 0; i < allPatients.length; i++) {
        List<Records> rec = await fetchRecords(allPatients[i].id.toString());
        allPatients[i].records = rec;
        filteredPatients[i].records = rec;
      }

      update();
    } else {
      customSnackbar('Error', 'Failed to fetch patients', "error");
    }

    patientLoading = false;
    update();
  }

  fetchRecords(String id) async {
    var usr = await SharedPrefs().getUser();
    var token = json.decode(usr)['token'];

    var response = await http.get(
      Uri.parse('${baseUrl}patient-records?patient_id=$id'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    var res = await json.decode(response.body);

    if (res['success']) {
      return AllPatientsRecords.fromJson(res).data!.records!;
    } else {
      return [];
    }
  }

  fetchAllPatientRecords(String id) async {
    patientLoading = true;
    update();

    var usr = await SharedPrefs().getUser();
    var token = json.decode(usr)['token'];

    var response = await http.get(
      Uri.parse('${baseUrl}patient-records?patient_id=$id'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    var res = await json.decode(response.body);

    if (res['success']) {
      patientRecords = AllPatientsRecords.fromJson(res).data!.records!;
      update();
    } else {
      customSnackbar('Error', 'Failed to fetch patient records', "error");
    }

    patientLoading = false;
    update();
  }

  addPatient() async {
    if (nameController.text == '' ||
        phoneController.text == '' ||
        addressController.text == '' ||
        descriptionController.text == '') {
      customSnackbar('Error', 'Please fill all the forms', 'error');
      return;
    }

    patientLoading = true;
    update();

    var usr = await SharedPrefs().getUser();
    var token = json.decode(usr)['token'];

    var url = Uri.parse('${baseUrl}patients');
    var request = http.MultipartRequest("POST", url);
    request.headers["accept"] = 'application/json';
    request.headers["Content-Type"] = 'multipart/form-data';
    request.headers["Authorization"] = 'Bearer $token';

    request.fields["name"] = nameController.text;
    request.fields["address"] = addressController.text;
    request.fields["dob"] = selectedDate;
    request.fields["gender"] = gender;
    request.fields["phone"] = phoneController.text;
    request.fields["ward"] = ward;
    request.fields["description"] = descriptionController.text;
    request.fields["conditions"] = condition;

    if (imageFile != null) {
      var pic = await http.MultipartFile.fromPath("image", imageFile!.path);
      request.files.add(pic);
    }
    var response = await request.send();

    var resp = await response.stream.transform(utf8.decoder).join();
    var res = json.decode(resp);

    if (res['success']) {
      resetFields();
      Get.back();
      customSnackbar('Success', res['message'][0], 'success');
    } else {
      customSnackbar('Error', res['message'][0], 'error');
    }

    Future.delayed(Duration(seconds: 1), () async {
      await fetchAllPatients();
    });

    patientLoading = false;
    update();
  }

  editPatient(String id) async {
    if (nameController.text == '' ||
        phoneController.text == '' ||
        addressController.text == '' ||
        descriptionController.text == '') {
      customSnackbar('Error', 'Please fill all the forms', 'error');
      return;
    }

    patientLoading = true;
    update();

    var usr = await SharedPrefs().getUser();
    var token = json.decode(usr)['token'];

    var url = Uri.parse('${baseUrl}patients/update/$id');
    var request = http.MultipartRequest("POST", url);
    request.headers["accept"] = 'application/json';
    request.headers["Content-Type"] = 'multipart/form-data';
    request.headers["Authorization"] = 'Bearer $token';

    request.fields["name"] = nameController.text;
    request.fields["address"] = addressController.text;
    request.fields["dob"] = selectedDate;
    request.fields["gender"] = gender;
    request.fields["phone"] = phoneController.text;
    request.fields["ward"] = ward;
    request.fields["description"] = descriptionController.text;
    request.fields["conditions"] = condition;

    if (imageFile != null) {
      var pic = await http.MultipartFile.fromPath("image", imageFile!.path);
      request.files.add(pic);
    }
    var response = await request.send();

    var resp = await response.stream.transform(utf8.decoder).join();
    var res = json.decode(resp);

    if (res['success']) {
      await fetchAllPatients();
      resetFields();
      Get.back();
      customSnackbar('Success', res['message'][0], 'success');
    } else {
      customSnackbar('Error', res['message'][0], 'error');
    }

    patientLoading = false;
    update();
  }

  deletePatient(id) async {
    patientLoading = true;
    update();

    var usr = await SharedPrefs().getUser();
    var token = json.decode(usr)['token'];

    var response = await http.delete(Uri.parse('${baseUrl}patients/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    var res = await json.decode(response.body);
    print(response.body);
    Get.back();

    if (res['success']) {
      await fetchAllPatients();
      customSnackbar('Success', res['message'][0], "success");
    } else {
      customSnackbar('Error', res['message'][0], "error");
    }

    patientLoading = false;
    update();
  }

  resetFields() {
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    descriptionController.clear();
    imageFile = null;
    ward = 'GENERAL';
    condition = 'Normal';
    gender = 'M';
    selectedDate = DateTime.now().toString().split(' ')[0];
    update();
  }

  prefillFields(Patient patient) {
    nameController.text = patient.name!;
    phoneController.text = patient.phone!;
    selectedDate = patient.dob.toString();
    addressController.text = patient.address!;
    descriptionController.text = patient.description!;
    ward = patient.ward!;
    condition = patient.conditions!;
    gender = patient.gender!;
    update();
  }

  selectDate(context, {timeSlot = false}) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime.now());

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      if (timeSlot) {
        selectedDate = formattedDate;
        update();
        return formattedDate;
      } else {
        selectedDate = formattedDate;
      }
      update();
    } else {}
  }

  addPatientRecord(String id) async {
    if (bpController.text == '' ||
        rrController.text == '' ||
        boController.text == '' ||
        hrController.text == '') {
      customSnackbar('Error', 'Please fill all the forms', 'error');
      return;
    }

    patientLoading = true;
    update();

    var usr = await SharedPrefs().getUser();
    var token = json.decode(usr)['token'];

    var response = await http.post(
        Uri.parse('${baseUrl}patient-records?page=1&per_page=100'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          "patient_id": id,
          "blood_pressure": bpController.text,
          "respiratory_rate": rrController.text,
          "blood_oxygen": boController.text,
          "heart_beat": hrController.text,
          "date": selectedDate
        }));
    var res = await json.decode(response.body);
    print(response.body);

    if (res['success']) {
      await fetchAllPatients();
      await fetchAllPatientRecords(id);
      resetRecordsFields();
      Get.back();
      Get.back();
      customSnackbar('Success', res['message'][0], 'success');
    } else {
      customSnackbar('Error', res['message'][0], 'error');
    }

    patientLoading = false;
    update();
  }

  editPatientRecord(String id, String recordId) async {
    if (bpController.text == '' ||
        rrController.text == '' ||
        boController.text == '' ||
        hrController.text == '') {
      customSnackbar('Error', 'Please fill all the forms', 'error');
      return;
    }

    patientLoading = true;
    update();

    var usr = await SharedPrefs().getUser();
    var token = json.decode(usr)['token'];

    var response =
        await http.post(Uri.parse('${baseUrl}patient-records/update/$recordId'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode({
              "patient_id": id,
              "blood_pressure": bpController.text,
              "respiratory_rate": rrController.text,
              "blood_oxygen": boController.text,
              "heart_beat": hrController.text,
              "date": selectedDate
            }));
    var res = await json.decode(response.body);
    print(response.body);

    if (res['success']) {
      await fetchAllPatients();
      await fetchAllPatientRecords(id);
      resetRecordsFields();
      Get.back();
      Get.back();
      customSnackbar('Success', res['message'][0], 'success');
    } else {
      customSnackbar('Error', res['message'][0], 'error');
    }

    patientLoading = false;
    update();
  }

  deletePatientRecords(String id, context) async {
    patientLoading = true;
    update();

    var usr = await SharedPrefs().getUser();
    var token = json.decode(usr)['token'];

    var response = await http.delete(Uri.parse('${baseUrl}patient-records/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    var res = await json.decode(response.body);
    print(response.body);

    if (res['success']) {
      Navigator.pop(context);
      await fetchAllPatientRecords(id);
      customSnackbar('Success', res['message'][0], "success");
    } else {
      customSnackbar('Error', res['message'][0], "error");
    }

    patientLoading = false;
    update();
  }

  resetRecordsFields() {
    bpController.clear();
    rrController.clear();
    boController.clear();
    hrController.clear();
    selectedDate = DateTime.now().toString().split(' ')[0];
    update();
  }

  prefillRecordsFields(Records records) {
    bpController.text = records.bloodPressure!;
    rrController.text = records.respiratoryRate!;
    boController.text = records.bloodOxygen!;
    hrController.text = records.heartBeat!;
    selectedDate = records.date.toString().split(' ')[0];
    update();
  }
}
