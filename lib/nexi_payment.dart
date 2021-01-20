import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:nexi_payment/models/environment_utils.dart';

import 'models/api_front_office_qp_request.dart';

class NexiPayment {
  static const MethodChannel _channel = const MethodChannel('nexi_payment');

  ///secretKey from backend
  String secretKey;

  ///environment type could be: TEST, PROD. Default -> TEST
  String environment = EnvironmentUtils.TEST;

  NexiPayment({@required this.secretKey, this.environment});

  //Initialize XPay object with the activity
  Future<String> _initXPay(String secretKey, String environment) async {
    var res = await _channel.invokeMethod(
        "initXPay", {"secretKey": secretKey, "environment": environment});
    return res;
  }

  //Initialize XPay object with the activity
  Future<String> _initXPayWithDomain(
      String secretKey, String environment, String domain) async {
    var res = await _channel.invokeMethod("initXPay",
        {"secretKey": secretKey, "environment": environment, "domain": domain});
    return res;
  }

  //Makes the web view payment and awaits the response
  Future<String> xPayFrontOfficePaga(
      String alias, String codTrans, String currency, int amount) async {
    await _initXPay(secretKey, environment);
    ApiFrontOfficeQPRequest request =
        new ApiFrontOfficeQPRequest(alias, codTrans, currency, amount);
    var res =
        await _channel.invokeMethod("xPayFrontOfficePaga", request.toMap());
    return res;
  }

  Future<String> xPayFrontOfficePagaExtended(
      String alias, String codTrans, String currency, int amount,
      {String domain, Map<String, String> extraParameters}) async {
    if (domain != null) {
      await _initXPayWithDomain(secretKey, environment, domain);
    } else {
      await _initXPay(secretKey, environment);
    }
    ApiFrontOfficeQPRequest request =
        new ApiFrontOfficeQPRequest(alias, codTrans, currency, amount);
    request.extraKeys = extraParameters;
    var res =
        await _channel.invokeMethod("xPayFrontOfficePaga", request.toMap());
    return res;
  }
}
