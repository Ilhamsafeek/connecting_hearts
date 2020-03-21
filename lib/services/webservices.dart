import 'dart:convert';

import 'package:zamzam/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WebServices {
  ApiListener mApiListener;

  WebServices(this.mApiListener);

  Future<dynamic> getData() async {
    var response = await http.get("https://www.chadmin.online/api/projects");
    var jsonServerData = json.decode(response.body);
    
    return jsonServerData;
  }

  Future<String> updateUser(String userId, String appToken) async {
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    var url = 'https://www.chadmin.online/api/updateaccount';
    var response = await http.post(url, body: {
      'app_token': '$appToken',
      'phone': '$userId',
     
    });

    print(response.statusCode);
    print(response.body);
    return response.body;
  }

  Future createAccount(String contact) async {
    var url = 'https://www.chadmin.online/api/createaccount';
    var response = await http.post(url,
        body: {'name': 'ilham', 'phone': '$contact', 'role_id': '2'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<dynamic> getSermonData() async {
    var response = await http.get("https://chadmin.online/api/allsermons");
    var jsonServerData = json.decode(response.body);
    
    return jsonServerData;
  }


  Future<dynamic> getCategoryData() async {
    var response = await http.get("https://www.chadmin.online/api/allprojectcategories");
    var jsonServerData = json.decode(response.body);
    
    return jsonServerData;
  }
  Future<List<HistoryData>> getHistoryData() async {
    var user = await http.get('https://www.hashnative.com/gethistory');
    var jsonData = json.decode(user.body);
    print(user.body);
    List<HistoryData> datas = [];

    for (var d in jsonData) {
      HistoryData data = HistoryData(d["id"], d["type"], d["sender"],
          d["receiver"], d["time"], d["amount"]);
      datas.add(data);
    }
    return datas;
  }

  Future<List<BeneficiariesData>> getBeneficiaries() async {
    var user = await http.get("https://www.hashnative.com/getbeneficiaries");
    var jsonData = json.decode(user.body);

    List<BeneficiariesData> datas = [];

    for (var d in jsonData) {
      BeneficiariesData data =
          BeneficiariesData(d["id"], d["name"], d["added_by"], d["mobile"]);
      datas.add(data);
    }
    return datas;
  }

  Future<String> addBeneficiary(String mobile, String addedBy) async {
    var url = 'https://www.hashnative.com/addbeneficiary';
    var response = await http.post(url,
        body: {'added_by': '$addedBy', 'mobile': '$mobile', 'name': 'safeek'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response.body;
  }

  Future<String> deleteBeneficiary(String mobile, String addedBy) async {
    var url = 'https://www.hashnative.com/deleteBeneficiary';
    var response = await http
        .post(url, body: {'added_by': '$addedBy', 'mobile': '$mobile'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response.body;
  }
}

class HistoryData {
  final String id;
  final String amount;
  final String type;
  final String sender;
  final String receiver;
  final String time;

  HistoryData(
      this.id, this.type, this.sender, this.receiver, this.time, this.amount);
}

class BeneficiariesData {
  final String id;
  final String addedBy;
  final String name;
  final String mobile;

  BeneficiariesData(this.id, this.name, this.addedBy, this.mobile);
}
