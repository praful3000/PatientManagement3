import 'package:patient_management/models/patient_records.dart';

isCritical(List<Records> records) {
  if (records.isEmpty) return false;
  records.sort((a, b) => DateTime.parse(b.date.toString())
      .compareTo(DateTime.parse(a.date.toString())));
  Records latestRecords = records[0];

  String bloodPressure = latestRecords.bloodPressure!;
  String respiratoryRate = latestRecords.respiratoryRate!;
  String bloodOxygen = latestRecords.bloodOxygen!;
  String heartBeat = latestRecords.heartBeat!;

  if (bloodPressure.contains("/") && bloodPressure.split("/").length > 1) {
    if (int.parse(bloodPressure.split("/")[0]) >= 140) {
      return true;
    }
    if (int.parse(bloodPressure.split("/")[1]) >= 90) {
      return true;
    }
  }

  if (int.parse(respiratoryRate) <= 12 || int.parse(respiratoryRate) >= 25) {
    return true;
  }

  if (int.parse(bloodOxygen) <= 88) {
    return true;
  }

  if (int.parse(heartBeat) <= 60 || int.parse(heartBeat) >= 120) {
    return true;
  }

  return false;
}
