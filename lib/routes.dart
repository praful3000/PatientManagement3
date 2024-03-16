import 'package:get/get.dart';
import 'package:patient_management/screens/app/add_patient.dart';
import 'package:patient_management/screens/app/add_patient_records.dart';
import 'package:patient_management/screens/app/all_patients_screen.dart';
import 'package:patient_management/screens/app/single_patient.dart';

class GetRoutes {
  static const String allPatients = '/allPatients';
  static const String singlePatient = '/singlePatient';
  static const String addPatient = '/addPatient';
  static const String addPatientRecords = '/addPatientRecords';

  static List<GetPage> routes = [
    GetPage(
      name: GetRoutes.allPatients,
      page: () => AllPatientsScreen(),
    ),
    GetPage(
      name: GetRoutes.singlePatient,
      page: () => SinglePatient(),
    ),
    GetPage(
      name: GetRoutes.addPatient,
      page: () => AddPatient(),
    ),
    GetPage(
      name: GetRoutes.addPatientRecords,
      page: () => AddPatientRecords(),
    ),
  ];
}
