import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/screens/user/HomeScreen.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:http/http.dart' as http;
import 'package:webview_all/webview_all.dart';

class pay extends StatefulWidget {
  pay({required this.userId, required this.firstname, required this.lastname, required this.price, required this.applicationID, required this.isEnglish});
  final String applicationID;
  final int price;
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  State<pay> createState() => _payState();
}

class _payState extends State<pay> {
  bool isEnglish = true;
  late Timer _timer;
  bool _dialogClosed = false;

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  Future<String> getClientSecret(int amount) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/create-payment-intent'), // Update URL if necessary
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'amount': amount,
      }),
    );
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['clientSecret'];
    } else {
      throw Exception('Failed to load client secret');
    }
  }
  Future<void> showSuccessDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Success'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your payment was successful.'),
              ],
            ),
          ),

        );
      },
    );
  }

  Future<void> updatePayment(String applicationID) async {
    try {
      final response = await http.get(
        Uri.parse('http://$IP/palease_api/pay.php?applicationid=${widget.applicationID}'), // Update URL if necessary
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
        await showSuccessDialog(context);
      } else {
        print('Failed to update payment status');
      }
    } catch (e) {
      print('Error updating payment status: $e');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEnglish = widget.isEnglish;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(
        context,
        isEnglish ? 'Payment' : 'الدفع',
        widget.userId,
        widget.firstname,
        widget.lastname,
        isEnglish,
        _toggleLanguage,
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 150, 25, 50),
            child: ListView(
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20, right: 5),
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              final clientSecret = await getClientSecret(widget.price);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(isEnglish ? 'Pay' : 'ادفع'),
                                    content: Webview(
                                      url: 'http://127.0.0.1:8000/web/stripe/stripe_webview.html?clientSecret=$clientSecret&applicationID=${widget.applicationID}',
                                      appName: 'Payment',
                                    ),
                                  );
                                },
                              ).then((_) {
                                _dialogClosed = true;
                              });

                              _timer = Timer(Duration(seconds: 30), () {
                                if (!_dialogClosed) {
                                  updatePayment(widget.applicationID);
                                }
                              });
                            } catch (e) {
                              print('Failed to get client secret: $e');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                            minimumSize: Size(150, 55), // Set minimum button size
                            padding: const EdgeInsets.only(bottom: 0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/paypal.png'),
                                height: 40,
                              ),
                              Text(
                                isEnglish ? "Pay" : 'ادفع',
                                style: TextStyle(
                                  color: Color.fromRGBO(100, 19, 189, 1),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
