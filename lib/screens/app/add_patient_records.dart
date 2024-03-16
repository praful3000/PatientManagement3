import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:patient_management/controllers/patient_controller.dart';
import 'package:patient_management/models/patient_records.dart';
import 'package:patient_management/widgets/custom_appbar.dart';
import 'package:patient_management/widgets/custom_button.dart';

class AddPatientRecords extends StatelessWidget {
  const AddPatientRecords(
      {super.key, this.records, this.type = 'Add', this.id});

  final Records? records;
  final String type;
  final String? id;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientController>(builder: (controller) {
      return Scaffold(
        appBar: customAppbar('$type Records'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    controller.selectDate(context);
                  },
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFD9D9D9),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Date: ${controller.selectedDate}'),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        enabled: !controller.patientLoading,
                        controller: controller.bpController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFD9D9D9),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'B. P. (mmHg)'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        enabled: !controller.patientLoading,
                        controller: controller.rrController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFD9D9D9),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'R. Rate (X/min)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        enabled: !controller.patientLoading,
                        controller: controller.boController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFD9D9D9),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'B. O. Rate (X%)'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        enabled: !controller.patientLoading,
                        controller: controller.hrController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFD9D9D9),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'H.B. Rate (X / min)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                CustomButton(
                    loading: controller.patientLoading,
                    onPressed: () {
                      if (type == 'Edit') {
                        controller.editPatientRecord(
                            id!, records!.id.toString());
                      } else {
                        controller.addPatientRecord(id!);
                      }
                    },
                    label: '$type Record'),
              ],
            ),
          ),
        ),
      );
    });
  }
}
