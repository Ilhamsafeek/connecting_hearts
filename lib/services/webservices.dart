import 'dart:convert';

import 'package:zamzam/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:zamzam/constant/Constant.dart';
import 'dart:io';

class WebServices {
  ApiListener mApiListener;

  WebServices(this.mApiListener);

  Future<dynamic> getData() async {
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


  Future<int> updateUser(username, email) async {
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    var url = 'https://www.chadmin.online/api/updateaccount';
    var response = await http.post(url, body: {
      'username': '$username',
      'phone': '$CURRENT_USER',
      'email': '$email',
    });

    print(response.statusCode);
    print(response.body);
    return response.statusCode;
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

  Future<dynamic> getUserData() async {
    var url = 'https://www.chadmin.online/api/getuser';
    var response = await http.post(url, body: {
      'phone': CURRENT_USER,
    });
    var jsonServerData = json.decode(response.body);
    return jsonServerData;
  }

  // Payment records

  Future<dynamic> createPayment(amount, projectData, method, status) async {
    print('Calling API createPayment --------->>>>>>>');

    var url = 'https://www.chadmin.online/api/createpayment';
    var response = await http.post(url, body: {
      'user_id': CURRENT_USER,
      'amount': '$amount',
      'project_id': projectData['appeal_id'],
      'receipt_no': '123',
      'method': '$method',
      'status': '$status'
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

  Future<bool> updateSlip(id,path) async {
    String base64Image = base64Encode(File(path).readAsBytesSync());
    String fileName = File(path).path.split('/').last;
    print('id:: $id');
    http.post('https://www.chadmin.online/api/updateslip', body:{
      "id": "$id",
      "image": base64Image,
      "filename":fileName
    }).then((value) {
      print(value.body);
      return value.body;
    });

    return false;
  
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
    print("token body: ${response.body}") ;
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
    print("token=======> $jsonServerData");
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
    print(response.body);

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

  Future<dynamic> chargeByCustomerAndCardID(
      String card, paymentAmount, project) async {
    var customer;
    await getCustomerDataByMobile().then((value) {
      customer = value[0]['id'].toString();
      print("customer is $customer");
    });
    var url = 'https://api.stripe.com/v1/charges';

    var response = await http.post(
      url,
      body: {
        'amount': '$paymentAmount',
        'currency': 'lkr',
        'description': 'Donation for project $project',
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

  Future<bool> isCardExist(customer, last4) async {
    var url =
        'https://api.stripe.com/v1/customers/$customer/sources?object=card';

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer sk_test_BFCJjwXJ4kMjb24UchyGQg2v007BePNKeK"
      },
    );

    var jsonServerData = json.decode(response.body);

    for (var val in jsonServerData['data']) {
      if (val['last4'] == last4) return true;
    }

    return false;
  }

  Future<dynamic> saveCard(cardNumber, expiryMonth, expiryYear, cvc) async {
    var token;
    var card;
    var last4;
    dynamic result;
    await createStripeToken(cardNumber, expiryMonth, expiryYear, cvc)
        .then((value) {
      token = value['id'];
      card = value['card']['id'];
      last4 = value['card']['last4'];
    });
    var customer;

    if (await isAlreadyCustomer()) {
      //Yes
      await getCustomerDataByMobile().then((value) {
        if (value.length != 0) {
          customer = value[0]['id'];
        }
      });
      if (await isCardExist(customer, last4)) {
        print("Card Added Already");
        result = "Card Added Already";
      } else {
        await addCardTokenToCustomer(customer, token).then((value) {
          print("Card Added Succesfully");

          result = true;
        });
      }
    } else {
      //No
      await saveCustomer(token).then((value) {
        print('card : $card');
        print("Customer registered and Card Added Successfully");
        result = true;
      });
    }
    return result;
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

  Future<dynamic> isCardValid(cardNumber, expiryMonth, expiryYear, cvc) async {
    //creating card token will help to validate
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

    var jsonServerData = json.decode(response.body);
    if (jsonServerData['id'] != null) {
      print('card is valid');
      return true;
    }
    return jsonServerData['error']['message'];
  }
}
