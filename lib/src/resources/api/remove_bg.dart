import 'dart:typed_data';
import 'package:http/http.dart' as http;

class RemoveBg {

  Future<Uint8List> removieBgApi(String imagePath) async {
    var request = http.MultipartRequest("Post", Uri.parse("https://api.remove.bg/v1.0/removebg"));

    request.files.add(await http.MultipartFile.fromPath("image_file", imagePath));
    request.headers.addAll({"X-API-KEY" : "zAqq21MTWYvDCGR8i2tDKXvp"});
    var response = await request.send();

    if(response.statusCode == 200){
      http.Response imgRes = await http.Response.fromStream(response);
      return imgRes.bodyBytes;
    }
    else{
      throw Exception("Error occurred with response ${response.statusCode}");
    }
  }
}