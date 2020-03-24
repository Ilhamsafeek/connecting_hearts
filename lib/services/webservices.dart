import 'dart:convert';

import 'package:zamzam/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:zamzam/Tabs.dart';

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

  Future<dynamic> getStripeResponse() async {
    var response = await http.get("https://www.chadmin.online/api/projects");
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

//Stripe Payment
  //Sources :
  //1. https://medium.com/devmins/stripe-implementation-payment-gateway-integration-postman-collection-ded68a115667
  //2.  https://medium.com/devmins/stripe-implementation-part-ii-payment-gateway-integration-postman-collection-7d37efee096d
  Future<dynamic> createStripeToken() async {
    var url = 'https://api.stripe.com/v1/tokens';
    var response = await http.post(
      url,
      body: {
        'card[number]': '4242424242424242',
        'card[exp_month]': '12',
        'card[exp_year]': '2020',
        'card[cvc]': '123',
      },
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer sk_test_BFCJjwXJ4kMjb24UchyGQg2v007BePNKeK"
      },
    );
    // print(response.body) ;
    var jsonServerData = json.decode(response.body);
    print(jsonServerData['id']);
    return jsonServerData;
  }

  Future<dynamic> saveCustomer(String token) async {
    //it will return customer id aswell
    var url = 'https://api.stripe.com/v1/customers';
    var response = await http.post(
      url,
      body: {
        'description': 'customer for connecting hearts',
        'source': '$token',
        'phone': '$token',
      },
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer sk_test_BFCJjwXJ4kMjb24UchyGQg2v007BePNKeK"
      },
    );
    // print(response.body) ;
    var jsonServerData = json.decode(response.body);
    print(jsonServerData['id']);
    return jsonServerData;
  }

  // charge directly with token
  Future<dynamic> stripeCharges(String token) async {
    var url = 'https://api.stripe.com/v1/charges';
    var response = await http.post(
      url,
      body: {
        'amount': '10000',
        'currency': 'lkr',
        'description': 'charged for project WI201',
        'source': '$token',
      },
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer sk_test_BFCJjwXJ4kMjb24UchyGQg2v007BePNKeK"
      },
    );
    // print(response.body) ;

    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> addCardTokenToCustomer(String customer, String token) async {
    var url = 'https://api.stripe.com/v1/customers/$customer/sources';
    var response = await http.post(
      url,
      body: {
        'source': '$token',
      },
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer sk_test_BFCJjwXJ4kMjb24UchyGQg2v007BePNKeK"
      },
    );
    // print(response.body) ;

    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> getCustomerData(String customer) async {
    var url = 'https://api.stripe.com/v1/customers/$customer';
    var response = await http.post(
      url,
      body: {},
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer sk_test_BFCJjwXJ4kMjb24UchyGQg2v007BePNKeK"
      },
    );
    // print(response.body) ;

    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> getCustomerDataByMobile(String phone) async {
    var url = 'https://api.stripe.com/v1/customers';
    var response = await http.post(
      url,
      body: {
        'phone': '$phone',   
      },
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer sk_test_BFCJjwXJ4kMjb24UchyGQg2v007BePNKeK"
      },
    );
    // print(response.body) ;

    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> chargeByCustomerAndCardID(String customer, String card) async {
    var url = 'https://api.stripe.com/v1/charges';
    var response = await http.post(
      url,
      body: {
        'amount': '10000',
        'currency': 'lkr',
        'description': 'charged for project WI201',
        'customer': '$customer',
        'source': '$card',
      },
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer sk_test_BFCJjwXJ4kMjb24UchyGQg2v007BePNKeK"
      },
    );
    // print(response.body) ;

    var jsonServerData = json.decode(response.body);

    return jsonServerData;
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
