import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/screens/admin/applications.dart';
import 'package:graduationprojectweb/screens/admin/chat/chatting.dart';
import 'package:graduationprojectweb/screens/admin/dashboardscreen.dart';
import 'package:graduationprojectweb/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class Notify extends StatefulWidget {
  const Notify({
    Key? key,
    required this.userId,
    required this.firstname,
    required this.lastname, required this.showNotify, required this.showapplications,
  }) : super(key: key);

  final String userId;
  final String firstname;
  final String lastname;
  final bool showNotify;
  final bool showapplications;

  @override
  State<Notify> createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  List<dynamic> applications = [];

  @override
  void initState() {
    super.initState();
    fetchApplications();
  }

  Future<void> fetchApplications() async {
    String uri = "http://$IP/palease_api/Notify.php";
    var response = await http.post(
      Uri.parse(uri),
      body: {
        "user_id": widget.userId,
      },
    );

    // Log the raw response
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['success']) {
        setState(() {
          applications = jsonData['applications'];
        });
      } else {
        _showErrorDialog(jsonData['error']);
      }
    } else {
      _showErrorDialog('Failed to fetch data from the server');
    }
  }


  Future<void> updateStatus(String applicationID, String applicationName,String applicant) async {
    String uri = "http://$IP/palease_api/updateNotify.php";
    var response = await http.post(
      Uri.parse(uri),
      body: {
        "applicationid": applicationID,
      },
    );
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['success']) {
        showMessageDialog(context, 'Completed', 'User has been notified successfully!');
        String deviceToken = await getToken(applicant);
        await sendFCMMessage(deviceToken,applicationName);
      } else {
        _showErrorDialog(jsonData['error']);
      }
    } else {
      _showErrorDialog('Failed to update status');
    }
  }

  Future<String> getToken(String id) async {
    try {
      String uri = "http://$IP/palease_api/gettoken.php?userid=$id";
      var response = await http.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData["success"]) {
          return responseData['token'];
        } else {
          print('Error: ${responseData["error"]}');
        }
      } else {
        print("HTTP error: ${response.statusCode}");
      }
    } catch (e) {
      print('Failed to get token: $e');
    }
    return '';
  }
  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {
        "type": "service_account",
        "project_id": "palease",
        "private_key_id": "85ba148f7b1f0ce9107540b30fa6fd2b644948af",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEugIBADANBgkqhkiG9w0BAQEFAASCBKQwggSgAgEAAoIBAQCzWY7urs776Cnu\neXYvg4SWlnTX8ujyMuoOWxr92laJujHWH+8uhD8Mq88JEoCenz4zbeF3DWYe3I58\nNjGh2XdS6CvGji6z4WvY3hWlTdbtsQlPDJkd7IhCzLHY/h6l69X+62NqSuL1CM8A\nLKJby6thB9OP/0znBgrUb5UiInK7e5auELFKNleRuss+yXTdtg+HWB8moEs4/16D\ny0Zjoc7v1cRl11oS4lThIcrZC4ooppft2PuC6ZxBM6XeGohHdZY41uSysrPPN7+M\nG0zUsV1wdxpXlRbSl9HOU76euVNNf3flizywAy0/KmEeCgl/r4sxjPeo/xN5bnka\nRflMmoxfAgMBAAECgf8PoW2CM6xLQYb04PCzAB2J+FL1+9hKmTd4EFh4Ag0gzRhg\nxO2zbmd2fkQyr5IczQziDSYOdDvvR9hxbFQBVpVB53npNHWR/f88GTcddmFlYFre\nEuOBeDcqDK5HM4sWf3j3J35CT6qvBWeJnmc08AIXOgd+9a/6lfQg4kIrw7Zka8So\nOzoXthLiWdvocm1ygLWjfsf6qJ33l5mkLCRxYXZ70mpVDM4MVANBugaRnFI/KvDp\nZERgQAyuka9jE49p0cP6WbKV257359UXPVABcpp8HC4TjQZRQRngMNKHzjs9OKVz\nEXbVZAnzMr4//vUEO4n+M5DynBvNHSZTh/RXhgECgYEA9n7K9UJZuIsyG80YFEvM\nDCCuzP22KnwMY+Clvk+HUNJyWRmnmzXe/OzRneux5II8Okf0jp0KO05jsyVatYEu\nzkRcCa4jbwmU/DUPg47L4fTNzpc3MjD7k2r2GyjBDZd+1l56lS9GEMjf2+/KbdJP\nNaUqQ0b6PyroCRWVAgox+18CgYEAukP1Zc3KoHdTv0yxpfQ0oGTRREaglklmdO7E\neC3T8Qxs8R6Sh2JXf5Vp25+UrWYdziUlYWTJI7sDpvdWis6msexBk8j3fgWaV0YP\nM4h7uungamkeBEKloK+CZBUR894jV2wZw5OTX+yndZ7xfmG6l+WkOk724uSRT3Ra\nzlgSDwECgYBQaeTERjUG40Ihl7L3TBLxEeh0r4AyM+3G1466my9FyqHLN3daRyTL\n1mY74pxSM7p6OOcrb0fbOSOFWfZRqCcg22Q7NDgTDUkxTg4VmQwiVr6dWu+CzEAG\nQ6quCYmRaY7TWFcdPCLbbuy4z212jlmQ4qT69bjFyrWP4R6PX8wWeQKBgB+3KJaw\nBrtx9gGRtoHyZe+VmwhMGlXco6Rvb2ajLv5RRk98DCkfNpTTxRWPQ4qO465RJt9B\ngPojgsiwPr0d2MZc2wGl63Y6z//iPv5gU+kMn5ie02yYSIlmuQX/jHIAtfXRw0VI\n4IQp0I23hZkmXNY2VNNU1LbnglKMFlYiKtkBAoGAfiMMjDs65cJ+1ueThMRtil/f\nBEI2OFizZg7RvJ9zHhA9MLrPl2wLk6SHAyUWMGG4+hekTqtQ0sZrkTRJoOBS6LXZ\nE+NEK6RKJQxo2AIEBjwTAhao3027seHrodwPZjoYQscfY6n1vZ4HQK4MemYT+QXf\nZvGbVWBlTmljvPFIIJ0=\n-----END PRIVATE KEY-----\n",
        "client_email": "firebase-adminsdk-96di9@palease.iam.gserviceaccount.com",
        "client_id": "107405382467024958425",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-96di9%40palease.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"


    };
    

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // Obtain the access token
    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client
    );

    // Close the HTTP client
    client.close();

    // Return the access token
    return credentials.accessToken.data;

  }

  Future<void> sendFCMMessage(String Token, String ApplicationName) async {
    final String serverKey = await getAccessToken() ; // Your FCM server key
    final String fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/palease/messages:send';
    final Map<String, dynamic> message = {
      'message': {
        'token': Token, // Token of the device you want to send the message to
        'notification': {
          'body': 'Your ${ApplicationName} Document is now ready, you can come and get it any time',
          'title': 'Application Ready'
        },
        'data': {
          'current_user_fcm_token': Token, // Include the current user's FCM token in data payload
        },
      }
    };

    final http.Response response = await http.post(
      Uri.parse(fcmEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('FCM message sent successfully');
    } else {
      print('Failed to send FCM message: ${response.statusCode}');
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showMessageDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  int _selectedIndex = 0;
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    if(widget.showNotify && widget.showapplications){
      setState(() {
        _selectedIndex=1;
      });
    }
    return Scaffold(

      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          NavigationRail(
            extended: isExpanded,
            backgroundColor: Colors.deepPurple.shade400,
            unselectedIconTheme:
            IconThemeData(color: Colors.white, opacity: 1),
            unselectedLabelTextStyle: TextStyle(
              color: Colors.white,
            ),
            selectedIconTheme:
            IconThemeData(color: Colors.deepPurple.shade900),
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text("Home"),
              ),
              if(widget.showNotify)
                NavigationRailDestination(
                  icon: Icon(Icons.bar_chart),
                  label: Text("Notify Users"),
                )
              ,if(widget.showapplications)
                NavigationRailDestination(
                  icon: Icon(Icons.book_outlined),
                  label: Text("Applications"),
                ),
              NavigationRailDestination(
                icon: Icon(Icons.move_to_inbox),
                label: Text("inbox"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.logout),
                label: Text("Log Out"),
              ),
            ],
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index; // Update the selectedIndex state variable

                // Perform actions based on the selected index
                switch (index) {
                  case 0:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardScreen(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname)),
                    );
                    break;
                  case 1:
                  // Action for Reports
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Notify(
                              userId: widget.userId,
                              firstname: widget.firstname,
                              lastname: widget.lastname,
                              showNotify:true,
                              showapplications:true)),
                    );
                    break;
                  case 2:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Applications(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname,showNotify:widget.showNotify,showapplications:widget.showapplications)),
                    );
                    break;
                  case 3:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname,showNotify:widget.showNotify,showapplications:widget.showapplications)),
                    );
                    break;
                  case 4:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const home()),
                    );
                    break;
                  default:
                  // Default action or error handling
                    break;
                }
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: Icon(Icons.menu),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top:28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child:     applications.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      border: TableBorder(),
                      columns: const [
                        DataColumn(label: Text('Application ID',style: TextStyle(color: Colors.deepPurple, fontSize: 25,fontFamily: 'SansSerif'),),),
                        DataColumn(label: Text('Application Name',style: TextStyle(color: Colors.deepPurple, fontSize: 25,fontFamily: 'SansSerif'))),
                        DataColumn(label: Text('User ID',style: TextStyle(color: Colors.deepPurple, fontSize: 25,fontFamily: 'SansSerif'))),
                        DataColumn(label: Text('Estimated Date ',style: TextStyle(color: Colors.deepPurple, fontSize: 25,fontFamily: 'SansSerif'))),
                        DataColumn(label: Text('Notify',style: TextStyle(color: Colors.deepPurple, fontSize: 25,fontFamily: 'SansSerif'))),
                      ],
                      rows: applications.map((application) {
                        return DataRow(cells: [
                          DataCell(Text(application['application_id'].toString())),
                          DataCell(Text(application['application_name'])),
                          DataCell(Text(application['applicant'].toString())),
                          DataCell(Text(application['Estimated_date'].toString())),
                          DataCell(
                            ElevatedButton(
                              onPressed: () {
                                updateStatus(application['application_id'].toString(), application['application_name'],application['applicant'].toString());
                              },
                              child: Text('Notify'),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),

                )
              ],
            ),
          ),


    ],
      ),
    );
  }
}
