import 'package:flutter/material.dart';
import 'package:nexi_payment/models/currency_utils_qp.dart';
import 'package:nexi_payment/models/environment_utils.dart';
import 'package:nexi_payment/nexi_payment.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  NexiPayment _nexiPayment;

  @override
  void initState() {
    super.initState();
    _nexiPayment = new NexiPayment(
        secretKey: "0TUY3S5UOQQIEVNJF7GM94GW4KWOAHWY",
        environment: EnvironmentUtils.TEST);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            RaisedButton(
                child: Text("PAY"), onPressed: () => _paga("insert_cod_trans")),
          ])),
    );
  }

  void _paga(String codTrans) async {
    var res = await _nexiPayment.xPayFrontOfficePagaExtended(
        "ALIAS_WEB_00026746", codTrans, CurrencyUtilsQP.EUR, 2500,
        domain: "https://int-ecommerce.nexi.it/ecomm/ecomm/DispatcherServlet",
        extraParameters: {
          'urlpost': 'http://10.198.2.41:8081/ecweb/api/pagamenti/nexis2s',
          'languageId': 'IT',
          'mail': 'sviluppo@projectsrl.com',
        });
    openEndPaymentDialog(res);
  }

  openEndPaymentDialog(String response) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext c2) {
        return AlertDialog(
          title: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: -12,
                    left: -15,
                    child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.blueAccent,
                        onPressed: () => Navigator.of(context).pop()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.euro_symbol,
                          color: Colors.black38,
                          size: 25,
                        ),
                      ),
                      Text(
                        "Response",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black38,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(response,
                  style: TextStyle(
                      color: response == "OK" ? Colors.green : Colors.red))
            ],
          ),
        );
      },
    );
  }
}
