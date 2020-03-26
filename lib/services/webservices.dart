import 'dart:convert';

import 'package:zamzam/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:zamzam/Tabs.dart';
import 'package:zamzam/constant/Constant.dart';

class WebServices {
  ApiListener mApiListener;

  WebServices(this.mApiListener);

  Future<dynamic> getData() async {
    var response = await http.get("https://www.chadmin.online/api/projects");
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<String> updateUser(String appToken) async {
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

  Future<dynamic> getStripeResponse() async {
    var response = await http.get("https://www.chadmin.online/api/projects");
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

//Stripe Payment
  //Sources :
  //1. https://medium.com/devmins/stripe-implementation-payment-gateway-integration-postman-collection-ded68a115667
  //2.  https://medium.com/devmins/stripe-implementation-part-ii-payment-gateway-integration-postman-collection-7d37efee096d
  Future<dynamic> createStripeToken(
      cardNumber, expiryMonth, expiryYear, cvc) async {
        print("Exp month: $expiryMonth");
    var url = 'https://api.stripe.com/v1/tokens';
    var response = await http.post(
      url,
      body: {
        'card[number]': '$cardNumber',
        'card[exp_month]': '$expiryMonth',
        'card[exp_year]': '$expiryYear',
        'card[cvc]': '$cvc',
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

  //create customer by adding card token
  Future<dynamic> saveCustomer(String token) async {
    //it will return customer id aswell
    var url = 'https://api.stripe.com/v1/customers';
    var response = await http.post(
      url,
      body: {
        'description': 'customer for connecting hearts',
        'source': '$token',
        'phone': '$CURRENT_USER',
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

  //create customer with mobile number
  Future<dynamic> createCustomer() async {
    //it will return customer id aswell
    var url = 'https://api.stripe.com/v1/customers';
    var response = await http.post(
      url,
      body: {
        'description': 'customer for connecting hearts',
        'phone': '$CURRENT_USER',
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
        'description': 'donation for project WI201',
        'source': '$token',
      },
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer sk_test_BFCJjwXJ4kMjb24UchyGQg2v007BePNKeK"
      },
    );
     print(response.body) ;

    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> addCardTokenToCustomer(String customer, String card) async {
    var url = 'https://api.stripe.com/v1/customers/$customer/sources';
    var response = await http.post(
      url,
      body: {
        'source': '$card',
      },
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer sk_test_BFCJjwXJ4kMjb24UchyGQg2v007BePNKeK"
      },
    );
    // print(response.body) ;

    var jsonServerData = json.decode(response.body);
    print("addCardTokenToCustomer-> $jsonServerData");
    return jsonServerData;
  }

  Future<dynamic> getCustomerData(String customer) async {
    var url = 'https://api.stripe.com/v1/customers/$customer';
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer sk_test_BFCJjwXJ4kMjb24UchyGQg2v007BePNKeK"
      },
    );
    // print(response.body) ;

    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> getCustomerDataByMobile() async {
    var url = 'https://api.stripe.com/v1/customers';
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer sk_test_BFCJjwXJ4kMjb24UchyGQg2v007BePNKeK"
      },
    );
    var jsonServerData = json.decode(response.body);
    // print(jsonServerData['data']);

    return jsonServerData['data']
        .where((el) => el['phone'] == CURRENT_USER)
        .toList();
  }

  Future<dynamic> chargeByCustomerAndCardID(String card) async {

    var customer;
    await getCustomerDataByMobile().then((value) {
      customer = value[0]['id'].toString();
      print("customer is $customer");
      
    });
    var url = 'https://api.stripe.com/v1/charges';
    
    var response = await http.post(
      url,
      body: {
        'amount': '10000',
        'currency': 'lkr',
        'description': 'donation for project WI201',
        'customer': '$customer',
        'source': '$card',
      },
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer sk_test_BFCJjwXJ4kMjb24UchyGQg2v007BePNKeK"
      },
    );

    var jsonServerData = json.decode(response.body);
    print("customer is $customer");
    print(jsonServerData);
    return jsonServerData;
  }

  Future<bool> isAlreadyCustomer() async {
    var url = 'https://api.stripe.com/v1/customers';
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer sk_test_BFCJjwXJ4kMjb24UchyGQg2v007BePNKeK"
      },
    );

    var jsonServerData = json.decode(response.body);

    if (jsonServerData['data'].length != 0) {
      if (jsonServerData['data']
              .where((el) => el['phone'] == CURRENT_USER)
              .toList()[0]
              .length !=
          0) {
        return true;
      }
      return false;
    }
    return false;
  }

  Future<bool> isCardExist(customer, cardId) async {
    var url = 'https://api.stripe.com/v1/customers/$customer/sources/$cardId';

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer sk_test_BFCJjwXJ4kMjb24UchyGQg2v007BePNKeK"
      },
    );

    var jsonServerData = json.decode(response.body);
    print("isCardExist-> $jsonServerData");
    if (jsonServerData['id']!=null) {
      return true;
    }
    return false;
  }

  Future<bool> saveCard(cardNumber, expiryMonth, expiryYear, cvc) async {
    
    var token;
    var card;
    
    await createStripeToken(cardNumber, expiryMonth, expiryYear, cvc)
        .then((value) {
      token = value['id'];
      card = value['card']['id'];
      
    });
    var customer;

    if (await isAlreadyCustomer()) {
      //Yes
      await getCustomerDataByMobile().then((value) {
        if (value.length != 0) {
          customer = value[0]['id'];
        }
      });
      if (await isCardExist(customer, card)) {
        print("Card Added Already");
        return false;
      } else {
        await addCardTokenToCustomer(customer, token).then((value) {
          print("Card Added Succesfully");

          return true;
        });
      }
    } else {
      //No
      await saveCustomer(card).then((value) {
        print("Customer registered and Card Added Successfully");
        return true;
      });
    }
    return false;
  }

  Future<bool> deleteCard(String card) async {
    var customer;
    await getCustomerDataByMobile().then((value) {
      customer = value[0]['id'].toString();
      print("customer is $customer");
      
    });

    var url = 'https://api.stripe.com/v1/customers/$customer/sources/$card';
    var response = await http.delete(
      url,
     
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer sk_test_BFCJjwXJ4kMjb24UchyGQg2v007BePNKeK"
      },
    );
    var jsonServerData = json.decode(response.body);
    print(jsonServerData['deleted']);
    return jsonServerData['deleted'];
  }


  Future<bool> isCardValid() async {
    return true;
  }
}
