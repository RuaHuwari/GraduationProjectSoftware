import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graduationproject/screens/HomeScreen.dart';
//import 'package:graduation_project/edituserprofile.dart';
import 'package:http/http.dart' as http;
class Paypal extends StatefulWidget {
  Paypal(
      {Key? key,
        required this.applicationID,
        required this.price,
        required this.firstname,
        required this.userId,
        required this.lastname})
      : super(key: key);
  final String applicationID;
  final String price;
  final String firstname;
  final String userId;
  final String lastname;
  @override
  State<Paypal> createState() => _PaypalState();
}

class _PaypalState extends State<Paypal> {
  bool paymentSuccess = false;
  Future<void> sendPaymentToCraftsman(double totalPrice) async {
    try {
      // Replace 'YOUR_PAYMENT_API_ENDPOINT' with the actual endpoint on your server
      var response = await http.post(
        Uri.parse('YOUR_PAYMENT_API_ENDPOINT'),
        body: {
          'craftsman_id':
          widget.applicationID, // Replace with the actual craftsman's ID
          'total_price': totalPrice.toString(),
        },
      );

      if (response.statusCode == 200) {
        // Payment request sent successfully
        print('Payment request sent to craftsman');
      } else {
        // Handle error
        print(
            'Failed to send payment request to craftsman: ${response.reasonPhrase}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }

  double calculateTotal(double price, double duration) {
    // Assuming that 'price' and 'duration' are in String format
    price = double.parse(widget.price);
    return price;
  }

  void makefalse() {
    paymentSuccess = false;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!paymentSuccess)
                TextButton(
                    onPressed: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => PaypalCheckout(
                              sandboxMode: true,
                              clientId:
                              //  "Ab4neIi0v0xRt-2Gzb_BDujrl8oBGdQyvUy-I8ZYoCaRY57f9k9vCS1t5Bs9P8v9PWp2zcmNKtUjgGys",
                              "AVy0695lXrj02JBwfJVU59lR-V1kyY1gDENQvPYAe-QKYxGpa_GdcqcVukiNzUExQns3qxsxWmv9WmGb",
                              secretKey:
                              //"EAb26YnTm0KWxE0T8iH1ck9iFIXshPpC2_pxAfBMwsLdoCK05SgHcbSqHDVqxEZ9HbGSHafN0XABrLWx",
                              "EKgbqMy-EEQ8SHNRzlU4x_GCUDIThjZkwLhf53eIzF_qJ10FdhI-8X0eirc_9EENlDkR1ZS6b24H7txA",
                              returnURL: "success.snippetcoder.com",
                              cancelURL: "cancel.snippetcoder.com",
                              transactions: const [
                                {
                                  "amount": {
                                    "total": '1',
                                    "currency": "USD",
                                    "details": {
                                      "subtotal": '1',
                                      "shipping": '0',
                                      "shipping_discount": 0
                                    }
                                  },
                                  "description":
                                  "The payment transaction description.",
                                  "payment_options": {
                                    "allowed_payment_method":
                                    "INSTANT_FUNDING_SOURCE"
                                  },
                                  "item_list": {
                                    "items": [
                                      {
                                        "name": "A demo product",
                                        "quantity": 1,
                                        "price": '1',
                                        "currency": "USD"
                                      }
                                    ],

                                    // shipping address is not required though
                                    // "shipping_address": {
                                    //   "recipient_name": "Jane Foster",
                                    //   "line1": "Travis County",
                                    //   "line2": "",
                                    //   "city": "Austin",
                                    //   "country_code": "US",
                                    //   "postal_code": "73301",
                                    //   "phone": "+00000000",
                                    //   "state": "Texas"
                                    // },
                                  }
                                }
                              ],
                              note:
                              "Contact us for any questions on your order.",
                              onSuccess: (Map params) async {
                                // double duration = widget.duration
                                //     as double; // Update with the actual duration from your reservation
                                // double craftsmanPrice = widget.price
                                //     as double; // Update with the actual craftsman price

                                // double totalPrice =
                                //     calculateTotal(duration, craftsmanPrice);

                                // Send payment request to craftsman
                                // await sendPaymentToCraftsman(totalPrice);
                                Fluttertoast.showToast(
                                    msg: 'Payment successful.');
                                setState(() {
                                  paymentSuccess = true;
                                });
                              },
                              onError: (error) {
                                print("onError: $error");

                                //    Fluttertoast.showToast(msg: "Error");
                              },
                              onCancel: (params) {
                                print('cancelled: $params');
                              }),
                        ),
                      ),
                    },
                    child: const Text("Make Payment"))
              else
                Column(
                  children: [
                    Text(
                      "Payment Done Successfully",
                      style: TextStyle(
                        color: Color.fromARGB(
                            255, 55, 176, 237), // Set the color to green
                        fontSize: 18.0, // Adjust the font size if needed
                        fontWeight:
                        FontWeight.bold, // Optional: Add bold font weight
                      ),
                    ),
                    Image(
                      image: AssetImage("lib/icon/giphy.gif"),
                      width: 320,
                      height: 320,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print("done");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => homescreen(
                                 userId: widget.userId,
                              firstname:widget.firstname,
                              lastname:widget.lastname
                            ),
                          ),
                        );
                      },
                      child: Text("Done"),
                    ),
                  ],
                ),
            ],
          )),
    );
  }
}