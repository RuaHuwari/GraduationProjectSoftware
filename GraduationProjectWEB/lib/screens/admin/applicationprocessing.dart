import 'dart:typed_data';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/admin/Notify.dart';
import 'package:graduationprojectweb/screens/admin/chat/chatting.dart';
import 'package:graduationprojectweb/screens/admin/dashboardscreen.dart';
import 'package:graduationprojectweb/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:graduationprojectweb/screens/admin/applications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:archive/archive.dart';

class Application_Processing extends StatefulWidget {
  const Application_Processing({
    Key? key,
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.applicationID,
    required this.status,
    required this.applicantID, required this.showNotify, required this.showapplications,
  }) : super(key: key);

  final String userId;
  final String firstname;
  final String lastname;
  final String applicantID;
  final String status;
  final int applicationID;
  final bool showNotify;
  final bool showapplications;

  @override
  State<Application_Processing> createState() => _Application_ProcessingScreenState();
}

class _Application_ProcessingScreenState extends State<Application_Processing> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0;
  bool isExpanded = false;
  late int totalApplications;
  late int applicationsLastWeek;
  bool showbuttons = true;
  Map<String, dynamic> applicationData = {};
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    isExpanded = false;
    totalApplications = 0;
    applicationsLastWeek = 0;
    if (widget.status == 'accepted') {
      showbuttons = false;
    } else if (widget.status == 'rejected') {
      showbuttons = false;
    } else {
      showbuttons = true;
    }
    fetchDocumentById(widget.applicationID.toString());
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchDocumentById(String documentId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection("IDApplications")
          .where('id', isEqualTo: documentId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        throw Exception('Document not found');
      }
    } catch (e) {
      print('Error fetching document: $e');
      rethrow;
    }
  }
  Future<void> changestatus(String status,String userid) async {
    try {
      if (status == 'rejected') {
        String? rejectionReason = await showRejectionReasonDialog(context);
        if (rejectionReason == null) return;
        await updateStatus(status, rejectionReason,userid);
      } else if (status == 'accepted') {
        print(1);
        DateTime? selectedDate = await DatePicker(context);
        print(2);
        if (selectedDate == null) return;
        print(3);
        await updateStatus(status, selectedDate.toString(),userid);
      }
    } catch (e) {
      print(e);
      _showErrorDialog('An error occurred: $e');
    }
  }
  Future<void> updateStatus(String status, String data,String userid) async {
    String uri = "http://$IP/palease_api/changeStatus.php";
    var response = await http.post(
      Uri.parse(uri),
      body: {
        "applicationid": widget.applicationID.toString(),
        "status": status,
        "data": data,
      },
    );
    print(4);
    if (response.statusCode == 200) {
      print(5);
      var jsonData = jsonDecode(response.body);
      if (true) {
        print(6);
        showMessageDialog(context, 'Completed', 'Status of this Application has changed to $status successfully!');
        String deviceToken=await gettoken(userid);
        print(deviceToken);
        // Send notification to the user
        await sendNotification(deviceToken, status);
      } else {
        print(7);
        _showErrorDialog(jsonData['error']);
      }
    } else {
      print(8);
      _showErrorDialog('Failed to fetch data from the server');
    }
  }
  Future <String> gettoken(String id)async{
    try {
      print(9);
      String uri = "http://$IP/palease_api/gettoken.php?userid=$id";
      var response = await http.get(Uri.parse(uri));
      print(10);
      if (response.statusCode == 200) {
        // Parse the response JSON
        print(11);
        var responseData = jsonDecode(response.body);
        if (responseData["success"]) {
          print(12);
          return responseData['token'];
        } else {
          print(13);
          print('Error: ${responseData["error"]}');
        }
      } else {
        // Handle HTTP error
        print(14);
        print("HTTP error: ${response.statusCode}");
      }
    } catch (e) {
      print(15);
      print('Failed to get token: $e');
    }
    print(16);
    return '';
  }

  Future<void> sendNotification(String deviceToken, String status) async {
    const String serverKey = 'AAAAGRSjlfg:APA91bHq9kK0w4Jzu7G5B5nWhOKNXVjul2HQ5oCI9d_NhOrHp4wy982iv5Xzth0RHOcdcrzWqYUxpDNF-WmXek-O9o8psOWrtQrdFeO4i-Gl-71T80dqnRrdI_5BNi_edagXLQ-uCqT_';
    const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    try {
      var response = await http.post(
        Uri.parse(fcmUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(<String, dynamic>{
          'to': deviceToken,
          'notification': <String, dynamic>{
            'title': 'Status Changed',
            'body': 'The status of your application has changed to $status',
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
  Future<String?> showRejectionReasonDialog(BuildContext context) async {
    String? rejectionReason;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Rejection Reason'),
          content: TextField(
            onChanged: (value) {
              rejectionReason = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter reason here...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, rejectionReason);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );

    return rejectionReason;
  }
  Future<DateTime?> DatePicker(BuildContext context) async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: Colors.deepPurple,
            ),
          ),
          child: child!,
        );
      },
    );
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
  void showMessageDialog(BuildContext context, String text, String text2) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text),
          content: Text(text2),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Applications(
                          userId: widget.userId,
                          firstname: widget.firstname,
                          lastname: widget.lastname, showNotify: widget.showNotify, showapplications: widget.showapplications,)),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  String userid='';

  Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "palease",
      "private_key_id": "85ba148f7b1f0ce9107540b30fa6fd2b644948af",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEugIBADANBgkqhkiG9w0BAQEFAASCBKQwggSgAgEAAoIBAQCzWY7urs776Cnu\neXYvg4SWlnTX8ujyMuoOWxr92laJujHWH+8uhD8Mq88JEoCenz4zbeF3DWYe3I58\nNjGh2XdS6CvGji6z4WvY3hWlTdbtsQlPDJkd7IhCzLHY/h6l69X+62NqSuL1CM8A\nLKJby6thB9OP/0znBgrUb5UiInK7e5auELFKNleRuss+yXTdtg+HWB8moEs4/16D\ny0Zjoc7v1cRl11oS4lThIcrZC4ooppft2PuC6ZxBM6XeGohHdZY41uSysrPPN7+M\nG0zUsV1wdxpXlRbSl9HOU76euVNNf3flizywAy0/KmEeCgl/r4sxjPeo/xN5bnka\nRflMmoxfAgMBAAECgf8PoW2CM6xLQYb04PCzAB2J+FL1+9hKmTd4EFh4Ag0gzRhg\nxO2zbmd2fkQyr5IczQziDSYOdDvvR9hxbFQBVpVB53npNHWR/f88GTcddmFlYFre\nEuOBeDcqDK5HM4sWf3j3J35CT6qvBWeJnmc08AIXOgd+9a/6lfQg4kIrw7Zka8So\nOzoXthLiWdvocm1ygLWjfsf6qJ33l5mkLCRxYXZ70mpVDM4MVANBugaRnFI/KvDp\nZERgQAyuka9jE49p0cP6WbKV257359UXPVABcpp8HC4TjQZRQRngMNKHzjs9OKVz\nEXbVZAnzMr4//vUEO4n+M5DynBvNHSZTh/RXhgECgYEA9n7K9UJZuIsyG80YFEvM\nDCCuzP22KnwMY+Clvk+HUNJyWRmnmzXe/OzRneux5II8Okf0jp0KO05jsyVatYEu\nzkRcCa4jbwmU/DUPg47L4fTNzpc3MjD7k2r2GyjBDZd+1l56lS9GEMjf2+/KbdJP\nNaUqQ0b6PyroCRWVAgox+18CgYEAukP1Zc3KoHdTv0yxpfQ0oGTRREaglklmdO7E\neC3T8Qxs8R6Sh2JXf5Vp25+UrWYdziUlYWTJI7sDpvdWis6msexBk8j3fgWaV0YP\nM4h7uungamkeBEKloK+CZBUR894jV2wZw5OTX+yndZ7xfmG6l+WkOk724uSRT3Ra\nzlgSDwECgYBQaeTERjUG40Ihl7L3TBLxEeh0r4AyM+3G1466my9FyqHLN3daRyTL\n1mY74pxSM7p6OOcrb0fbOSOFWfZRqCcg22Q7NDgTDUkxTg4VmQwiVr6dWu+CzEAG\nQ6quCYmRaY7TWFcdPCLbbuy4z212jlmQ4qT69bjFyrWP4R6PX8wWeQKBgB+3KJaw\nBrtx9gGRtoHyZe+VmwhMGlXco6Rvb2ajLv5RRk98DCkfNpTTxRWPQ4qO465RJt9B\ngPojgsiwPr0d2MZc2wGl63Y6z//iPv5gU+kMn5ie02yYSIlmuQX/jHIAtfXRw0VI\n4IQp0I23hZkmXNY2VNNU1LbnglKMFlYiKtkBAoGBAN19IClzOgIN6Hp5gMoZhpEu\nqsPtbV/Ub+YNIBXLIV7t4ZZuTgrINt0aK4BZ+nux9hOSV+acEOasqbo\n65k1iMVUSADCNfWeij8i1EnP0c8l1ruWVzodtlpse18xfl+6Gc8STmO53e4uRey4\n2guUmhxPq2J7PcdFvJH3K5gzzC4ERUCS71p1iqfrRJZxjyTtnABkvoFLt7QzoLse\nb/Bm8rDE7ExwH5R+NGI=\n-----END PRIVATE KEY-----\n",
      "client_email": "palease@palease.iam.gserviceaccount.com",
      "client_id": "109346703167783682540",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/palease%40palease.iam.gserviceaccount.com"
    };
    final accountCredentials = auth.ServiceAccountCredentials.fromJson(serviceAccountJson);
    final scopes = [servicecontrol.ServiceControlApi.cloudPlatformScope];
    final authClient = await auth.clientViaServiceAccount(accountCredentials, scopes);
    final accessToken = (await authClient.credentials).accessToken.data;
    return accessToken;
  }

  Future<void> sendFCMMessage(String deviceToken, String status) async {
    String serverKey = 'YOUR_SERVER_KEY_HERE';
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode({
        'to': deviceToken,
        'notification': {
          'title': 'Application Status Changed',
          'body': 'The status of your application has been changed to $status',
        },
      }),
    );
    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }


  Future<Uint8List> _fetchImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
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
                    if(widget.showNotify)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Notify(
                                userId: widget.userId,
                                firstname: widget.firstname,
                                lastname: widget.lastname,showNotify:true,showapplications:true)),
                      );
                    else if(widget.showapplications){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Applications(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname,showNotify:widget.showNotify,showapplications:widget.showapplications)),
                      );
                    }
                    else    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname,showNotify:widget.showNotify,showapplications:widget.showapplications)),
                      );
                    break;
                  case 2:
                    if(widget.showNotify && widget.showapplications)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Applications(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname,showNotify:widget.showNotify,showapplications:widget.showapplications)),
                      );
                    else if(widget.showapplications)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname,showNotify:widget.showNotify,showapplications:widget.showapplications)),
                      );
                    else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const home()),
                      );
                    }
                    break;
                  case 3:
                    if(widget.showNotify && widget.showapplications)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname,showNotify:widget.showNotify,showapplications:widget.showapplications)),
                      );
                    else if(widget.showapplications){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const home()),
                      );
                    }
                    break;
                  case 4:
                    if(widget.showNotify&& widget.showapplications)
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
          Expanded(
            child: ListView(
              children: [
                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: fetchDocumentById(widget.applicationID.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.data() == null) {
                      return Center(child: Text('Document not found'));
                    } else {
                      final documentData = snapshot.data!.data()!;
                      final applicationDataEntries = documentData.entries.toList();

                      imageUrls.clear();
                      List<MapEntry<String, dynamic>> nonImageEntries = [];

                      for (var entry in applicationDataEntries) {
                        if (entry.key == 'user_id') {
                          userid = entry.value;
                          print('user_id: $userid');
                        }
                        if (Uri.tryParse(entry.value.toString())?.hasAbsolutePath == true) {
                          try {
                            final imageBytes = _fetchImage(entry.value.toString());
                            imageUrls.add(entry.value.toString());
                          } catch (e) {
                            print('Error downloading image: $e');
                            nonImageEntries.add(entry);
                          }
                        } else {
                          nonImageEntries.add(entry);
                        }
                      }

                      // Split nonImageEntries into chunks of two pairs for the table
                      List<List<MapEntry<String, dynamic>>> entryChunks = [];
                      for (int i = 0; i < nonImageEntries.length; i += 2) {
                        entryChunks.add(nonImageEntries.sublist(
                          i,
                          i + 2 > nonImageEntries.length ? nonImageEntries.length : i + 2,
                        ));
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Application ${widget.applicationID}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  if (showbuttons)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            changestatus('accepted', userid.toString());
                                          },
                                          child: Row(
                                            children: [
                                              Text('Accept', style: TextStyle(color: Colors.deepPurple)),
                                              Icon(Icons.check, color: Colors.deepPurple)
                                            ],
                                          ),
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                                        ),
                                        SizedBox(width: 16),
                                        ElevatedButton(
                                          onPressed: () {
                                            changestatus('rejected', userid.toString());
                                          },
                                          child: Row(
                                            children: [
                                              Text('Reject', style: TextStyle(color: Colors.deepPurple)),
                                              Icon(Icons.close, color: Colors.deepPurple)
                                            ],
                                          ),
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Application Details:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Table(
                                    border: TableBorder.all(color: Colors.black),
                                    columnWidths: const {
                                      0: FlexColumnWidth(1),
                                      1: FlexColumnWidth(2),
                                      2: FlexColumnWidth(1),
                                      3: FlexColumnWidth(2),
                                    },
                                    children: [
                                      for (var chunk in entryChunks)
                                        TableRow(
                                          children: [
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(chunk[0].key),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(chunk[0].value.toString()),
                                              ),
                                            ),
                                            if (chunk.length > 1)
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(chunk[1].key),
                                                ),
                                              ),
                                            if (chunk.length > 1)
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(chunk[1].value.toString()),
                                                ),
                                              ),
                                            if (chunk.length == 1) TableCell(child: SizedBox()), // Empty cells for alignment
                                            if (chunk.length == 1) TableCell(child: SizedBox()), // Empty cells for alignment
                                          ],
                                        ),
                                    ],
                                  ),
                                  if (imageUrls.isNotEmpty) ...[
                                    SizedBox(height: 16),
                                    Text(
                                      'Application Images:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    buildImageGrid(imageUrls),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          )

        ],
      ),
    );
  }

  Widget buildImageGrid(List<String> imageUrls) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: imageUrls.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
      itemBuilder: (context, index) {
        return Image.network(imageUrls[index]);
      },
    );
  }
}
