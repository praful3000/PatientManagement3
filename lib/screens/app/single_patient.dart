import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_management/controllers/patient_controller.dart';
import 'package:patient_management/models/patient.dart';
import 'package:patient_management/models/patient_records.dart';
import 'package:patient_management/routes.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:patient_management/screens/app/add_patient_records.dart';
import 'package:patient_management/utils/base_url.dart';
import 'package:patient_management/utils/critical.dart';
import 'package:patient_management/widgets/custom_button.dart';

// ignore: must_be_immutable
class SinglePatient extends StatelessWidget {
  SinglePatient({super.key});

  Patient patient = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${patient.name} - ',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              TextSpan(
                text: !isCritical(patient.records!) ? "Normal" : "Critical",
                style: TextStyle(
                  color:
                      !isCritical(patient.records!) ? Colors.green : Colors.red,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: GetBuilder<PatientController>(builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        patient.image!.substring(0, 4) == "http"
                            ? patient.image!
                            : imgUrl + patient.image!,
                        fit: BoxFit.cover,
                        height: 180,
                        width: 180,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${patient.ward}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        Text(
                          patient.name!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'DOB:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                              TextSpan(
                                text: ' ${patient.dob}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Sex:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: ' ${patient.gender}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Address:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                              TextSpan(
                                text: ' ${patient.address}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    patient.description!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Clinical Records',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  CustomButton(
                      onPressed: () {
                        showDialog(
                            context: (context),
                            builder: (context) {
                              return Dialog(
                                child: AddPatientRecords(
                                  id: patient.id.toString(),
                                ),
                              );
                            });
                        // Get.toNamed(GetRoutes.addPatientRecords,
                        //     arguments: [null, 'Add', patient.id.toString()]);
                      },
                      label: '+ Add Record')
                ],
              ),
              const SizedBox(height: 10),
              if (controller.patientLoading &&
                  controller.patientRecords.isEmpty)
                const CircularProgressIndicator(),
              if (!controller.patientLoading)
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 0.9,
                    children: controller.patientRecords
                        .map((e) => PatientRecordsCard(
                              records: e,
                              patient: patient,
                            ))
                        .toList(),
                  ),
                )
            ],
          ),
        );
      }),
    );
  }
}

class PatientRecordsCard extends StatelessWidget {
  const PatientRecordsCard(
      {super.key, required this.records, required this.patient});

  final Records records;
  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30000000),
            blurRadius: 7.90,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('yyyy MMM dd').format(records.date!),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'B. P.= ${records.bloodPressure} mmHg',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'R. Rate= ${records.respiratoryRate} / min',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'B. O. Rate= ${records.bloodOxygen}%',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'H.B. Rate= ${records.heartBeat} / min',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  final controller = Get.find<PatientController>();
                  controller.prefillRecordsFields(records);
                  // controller.editPatientRecord(
                  //     patient.id.toString(), records.id.toString());
                  // Get.toNamed(GetRoutes.addPatient,
                  //     arguments: [patient, 'Edit']);
                  showDialog(
                      context: (context),
                      builder: (context) {
                        return Dialog(
                          child: AddPatientRecords(
                            records: records,
                            type: 'Edit',
                            id: patient.id.toString(),
                          ),
                        );
                      });
                },
                child: Container(
                  height: 35,
                  width: 35,
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(17.5)),
                  child: const FaIcon(
                    FontAwesomeIcons.pencil,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          title: const Text('Delete Patient Record?'),
                          content: const Text('Delete this patient record?'),
                          actions: [
                            ElevatedButton(
                              child: const Text('Yes'),
                              onPressed: () async {
                                final controller =
                                    Get.find<PatientController>();
                                controller.deletePatientRecords(
                                    records.id.toString(), context);
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No',
                                  style: TextStyle(color: Colors.white)),
                            )
                          ],
                        );
                      });
                },
                child: Container(
                  height: 35,
                  width: 35,
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(17.5)),
                  child: const FaIcon(
                    FontAwesomeIcons.trash,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
