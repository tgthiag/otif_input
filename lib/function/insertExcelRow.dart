import 'dart:io';
import 'package:excel/excel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class xlsx {
  Future<void> insertExcelRow(List<String> dataList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String? fileUrl = prefs.getString('fileUrl');
print(fileUrl);
    if (fileUrl == null) {
      fileUrl = 'C:/file/registro.xlsx';
      await prefs.setString('fileUrl', fileUrl);
    }

    var bytes = File(fileUrl).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    var defaultSheet = excel.getDefaultSheet();
    Sheet sheetObject = excel[defaultSheet!];

    var item = sheetObject.appendRow(dataList);

    var fileBytes = excel.encode();
    File(fileUrl)..writeAsBytesSync(fileBytes!);
  }
}
// import 'dart:io';
// import 'package:excel/excel.dart';

// class xlsx {
//   Future<void> insertExcelRow(List<String> dataList) async {
//     var file = 'C:/file/registro.xlsx';
//     var bytes = File(file).readAsBytesSync();
//     var excel = Excel.decodeBytes(bytes);
//     var defaultSheet = excel.getDefaultSheet();
//     Sheet sheetObject = excel[defaultSheet!];

//     var item = sheetObject.appendRow(dataList);

//     var fileBytes = excel.encode();
//     File(file)..writeAsBytesSync(fileBytes!);
//   }
// }
