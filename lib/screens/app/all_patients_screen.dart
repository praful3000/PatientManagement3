import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:patient_management/controllers/patient_controller.dart';
import 'package:patient_management/models/patient.dart';
import 'package:patient_management/routes.dart';
import 'package:patient_management/screens/app/add_patient.dart';
import 'package:patient_management/utils/base_url.dart';
import 'package:patient_management/utils/critical.dart';
import 'package:patient_management/widgets/custom_appbar.dart';
import 'package:patient_management/widgets/custom_button.dart';

class AllPatientsScreen extends StatelessWidget {
  AllPatientsScreen({super.key});

  final patientController = Get.put(PatientController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        'Patient Management',
      ),
      body: GetBuilder<PatientController>(builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: DropdownButton(
                        underline: Container(),
                        value: controller.searchCondition,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: controller.conditions.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items,
                              style: TextStyle(
                                color: items == 'Select Condition'
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue == 'Select Condition') return;
                          controller.searchCondition = newValue!;
                          controller.searchPatients(
                              controller.searchText, newValue);
                          controller.update();
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.searchCondition != 'Select Condition' ||
                        controller.searchText.isNotEmpty,
                    child: InkWell(
                      onTap: () {
                        controller.searchCondition = 'Select Condition';
                        controller.searchText = '';
                        controller.searchPatients('', '');
                        controller.update();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x30000000),
                              blurRadius: 7.90,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Text(
                          'x',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomButton(
                      onPressed: () {
                        controller.resetFields();
                        // Get.toNamed(GetRoutes.addPatient);

                        showDialog(
                            context: (context),
                            builder: (context) {
                              return Dialog(
                                child: AddPatient(),
                              );
                            });
                      },
                      label: '+ Add')
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child:
                    controller.patientLoading && controller.allPatients.isEmpty
                        ? const CircularProgressIndicator()
                        : GridView.count(
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            crossAxisCount: 2,
                            children: controller.filteredPatients
                                .map((e) => PatientCard(patient: e))
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

class PatientCard extends StatelessWidget {
  const PatientCard({super.key, required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          final patientController = Get.find<PatientController>();
          patientController.fetchAllPatientRecords(patient.id.toString());
          Get.toNamed(GetRoutes.singlePatient, arguments: patient);
        },
        child: Stack(
          children: [
            Container(
              decoration: ShapeDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    patient.image!.substring(0, 4) == "http"
                        ? patient.image!
                        : imgUrl + patient.image!,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            Positioned(
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: const Alignment(0.00, -1.00),
                    end: const Alignment(0, 1),
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.7099999904632568)
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: !isCritical(patient.records!)
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        !isCritical(patient.records!) ? "Normal" : "Critical",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    Text(
                      patient.name!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'DOB: ${patient.dob.toString().split(' ')[0]}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Address: ${patient.address}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Ward: ${patient.ward}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      final controller = Get.find<PatientController>();
                      controller.prefillFields(patient);
                      // Get.toNamed(GetRoutes.addPatient,
                      //     arguments: [patient, 'Edit']);
                      showDialog(
                          context: (context),
                          builder: (context) {
                            return Dialog(
                              child: AddPatient(patient: patient, type: 'Edit'),
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
                              title: const Text('Delete Patient?'),
                              content: const Text('Delete this patient?'),
                              actions: [
                                ElevatedButton(
                                  child: const Text('Yes'),
                                  onPressed: () async {
                                    final controller =
                                        Get.find<PatientController>();
                                    controller.deletePatient(patient.id);
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
              ),
            )
          ],
        ));
  }
}
