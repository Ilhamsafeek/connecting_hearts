
import 'dart:convert';

import 'package:zamzam/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:zamzam/constant/Constant.dart';


class Braintree {
  ApiListener mApiListener;

  Braintree(this.mApiListener);

  
  Future<dynamic> sale(amount, paymentMethodNonce,projectData, method, status) async {
    var timestamp =new DateTime.now().millisecondsSinceEpoch;
    var url = 'https://www.chadmin.online/braintree/sale';
    var response = await http.post(url, body: {
      
      'paymentMethodNonce': '$paymentMethodNonce',
       'user_id': CURRENT_USER,
      'paid_amount': '$amount',
      'project_id': projectData['appeal_id'],
      'receipt_no': '$timestamp',
      'method': method,
      'status': status
    });
    // var jsonServerData = json.decode(response.body);
    return response.body;
   
  }

  
     
     

 


}
