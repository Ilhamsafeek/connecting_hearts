import 'dart:convert';

import 'package:zamzam/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:zamzam/constant/Constant.dart';
import 'dart:io';

class WebServices {
  ApiListener mApiListener;

  WebServices(this.mApiListener);

  Future<dynamic> getProjectData() async {
    var response = await http.get("https://www.chadmin.online/api/projects");
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<String> updateUserToken(String appToken) async {
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    var url = 'https://www.chadmin.online/api/updateaccount';
    var response = await http.post(url, body: {
      'app_token': '$appToken',
      'phone': '$CURRENT_USER',
    });

    print(response.statusCode);
    print(response.body);
    return response.body;
  }

  Future<int> updateUser(username, email, fname, lname) async {
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    var url = 'https://www.chadmin.online/api/updateaccount';
    var response = await http.post(url, body: {
      'username': '$username',
      'phone': '$CURRENT_USER',
      'email': '$email',
      'firstname': '$fname',
      'lastname': '$lname',
    });

    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

  Future createAccount(String contact) async {
    var url = 'https://www.chadmin.online/api/createaccount';
    var response =
        await http.post(url, body: {'phone': '$contact', 'role_id': '2'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<dynamic> getSermonData() async {
    var response = await http.get("https://chadmin.online/api/allsermons");
    var jsonServerData = json.decode(response.body);
    print("Response ${response.body}");
    return jsonServerData;
  }

  Future<dynamic> getCategoryData() async {
    var response =
        await http.get("https://www.chadmin.online/api/allprojectcategories");
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> getNotificationData() async {
    var response =
        await http.get("https://chadmin.online/api/allnotifications");
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> getUserData() async {
    var url = 'https://www.chadmin.online/api/getuser';
    var response = await http.post(url, body: {
      'phone': CURRENT_USER,
    });
    var jsonServerData = json.decode(response.body);
    return jsonServerData;
  }

  Future<dynamic> getZamzamUpdateData() async {
    var response = await http.get("https://chadmin.online/api/zamzamupdates");
    var jsonServerData = json.decode(response.body);
    print("Response ${response.body}");
    return jsonServerData;
  }

  Future<dynamic> getImageFromFolder(folder) async {
    print("=========>>>>>" + folder);
    var url = 'https://www.chadmin.online/api/getimagefile';
    var response = await http.post(url, body: {
      'project_supportives': folder,
    });

    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }


  // Payment records

  Future<dynamic> createPayment(amount, projectData, method, status) async {
    print('Calling API createPayment --------->>>>>>>');

    var timestamp = new DateTime.now().millisecondsSinceEpoch;
    print(' --------->>>>>>>$timestamp');
    var url = 'https://www.chadmin.online/api/createpayment';
    var response = await http.post(url, body: {
      'user_id': CURRENT_USER,
      'paid_amount': '$amount',
      'project_id': projectData['appeal_id'],
      'receipt_no': '$timestamp',
      'method': method,
      'status': status
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response.statusCode;
  }

  Future<dynamic> getPaymentData() async {
    var url = 'https://www.chadmin.online/api/getpayment';
    var response = await http.post(url, body: {
      'user_id': CURRENT_USER,
    });
    var jsonServerData = json.decode(response.body);
    return jsonServerData;
  }

  Future<bool> updateSlip(id, path) async {
    String base64Image = base64Encode(File(path).readAsBytesSync());
    String fileName = File(path).path.split('/').last;
    print('payment_id:: $id');
    http.post('https://www.chadmin.online/api/updateslip', body: {
      "payment_id": "$id",
      "image": base64Image,
      "filename": fileName
    }).then((value) {
      print(value.body);
      return value.body;
    });

    return false;
  }

  Future<dynamic> getCompanyData() async {
    var response = await http.get("https://chadmin.online/api/companydata");
    var jsonServerData = json.decode(response.body);
    print("Response ${response.body}");
    return jsonServerData;
  }

// Channels

  Future<dynamic> getChannelData() async {
    var response = await http.get("https://www.chadmin.online/api/channels");
    var jsonServerData = json.decode(response.body);
    print(jsonServerData);
    return jsonServerData;
  }

// Job
  Future<dynamic> getJobData() async {
    var url = 'https://www.chadmin.online/api/alljob';
    var response = await http.get(url);
    var jsonServerData = json.decode(response.body);
    return jsonServerData;
  }

  Future<int> postJob(type, title, location, minExperience, description,
      contact, email, image, organization) async {
    var url = 'https://www.chadmin.online/api/createjob';
    var response = await http.post(url, body: {
      'posted_by': CURRENT_USER,
      'type': '$type',
      'title': '$title',
      'location': '$location',
      'min_experience': '$minExperience years',
      'description': '$description',
      'contact': '$contact',
      'email': '$email',
      'image': '$image',
      'organization': '$organization',
    });
    print('Response status: ${response.statusCode}');
    return response.statusCode;
    // print('Response body: ${response.body}');
  }

  Future<int> deleteJob(id) async {
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    var url = 'https://www.chadmin.online/api/deletejob';
    var response = await http.post(url, body: {
      'id': '$id',
    });

    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

  Future<int> editJob(id, title, location, minExperience, description, contact,
      email, image, organization) async {
    var url = 'https://www.chadmin.online/api/editjob';
    var response = await http.post(url, body: {
      'id': '$id',
      'title': '$title',
      'location': '$location',
      'min_experience': '$minExperience',
      'description': '$description',
      'contact': '$contact',
      'email': '$email',
      'organization': '$organization',
    });

    return response.statusCode;
  }
}
