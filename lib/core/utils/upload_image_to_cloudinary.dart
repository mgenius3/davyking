// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;

// Future<String?> uploadImageToCloudinary(String imageFile) async {
//   try {
//     final url = Uri.parse('https://api.cloudinary.com/v1_1/dung0euqm/upload');

//     final request = http.MultipartRequest('POST', url)
//       ..fields['upload_preset'] = 'davyking'
//       ..files.add(await http.MultipartFile.fromPath('file', imageFile));

//     final response = await request.send();
//     if (response.statusCode == 200) {
//       final responseData = await response.stream.toBytes();
//       final responseString = String.fromCharCodes(responseData);
//       final jsonMap = jsonDecode(responseString);
//       final responseUrl = jsonMap['url'];
//       return responseUrl;
//     }
//     return null;
//   } catch (error) {
//     print(error.toString());
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> uploadImageToCloudinary(String imageFile) async {
  try {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dung0euqm/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'davyking'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      final responseUrl = jsonMap['url'];
      final public_id = jsonMap['public_id'];
      return {"image": responseUrl, "public_id": public_id};
    }
    return null;
  } catch (error) {
    print(error.toString());
  }
}
