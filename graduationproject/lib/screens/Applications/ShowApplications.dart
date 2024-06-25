import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduationproject/Constans/API.dart';
import 'package:graduationproject/Constans/colors.dart';
import 'package:graduationproject/widgets/bottomnavigation.dart';
import 'package:graduationproject/widgets/buildbutton.dart';
import 'package:http/http.dart' as http;

import '../payement.dart';
import '../printreport.dart';
class showapplications extends StatefulWidget {
  showapplications({ required this.userId, required this.firstname, required this.lastname, required this.status});
  final String userId;
  final String firstname;
  final String lastname;
  final String status;

  @override
  State<showapplications> createState() => _showapplicationsState();
}

class _showapplicationsState extends State<showapplications> {
  List<ApplicationData> applicationDataList = [];
  late int totalApplications;
  @override
  void initState() {
    super.initState();
    totalApplications = 0;
    fetchData(widget.status);
  }
  Future<void> fetchData(String? value) async {
    try {
      String uri = "http://$IP/palease_api/FetchApplications.php";
      var response = await http.post(
        Uri.parse(uri),
        body: {
          "user_id": widget.userId,
          "filter_by": value,
        },
      );
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['success']) {
          List<dynamic> applications = jsonData['applications'];

          setState(() {
            applicationDataList = applications
                .asMap()
                .entries
                .map((entry) => ApplicationData.fromJson(entry.value, entry.key))
                .toList();

            totalApplications = applicationDataList.length;
          });
        } else {
          _showErrorDialog(jsonData['error']);
        }
      } else {
        _showErrorDialog('Failed to fetch data from the server');
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    }
  }
  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('OOPS!',style:
            TextStyle(
              color: primary,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSerif'
            ),),
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
  String calculateTime(String dateString) {
    try {
      DateTime currentDate = DateTime.now();
      DateTime givenDate = DateTime.parse(dateString);

      Duration difference = givenDate.difference(currentDate);
      String prefix = (difference.isNegative) ? 'ago' : 'in';

      difference = difference.abs();

      int days = difference.inDays;
      int hours = difference.inHours.remainder(24); // Remaining hours after removing days
      int minutes = difference.inMinutes.remainder(60); // Remaining minutes after removing days and hours

      String result = '$prefix ';
      if (days > 0) {
        result += '$days day${days == 1 ? '' : 's'}';
        if (hours > 0 || minutes > 0) {
          result += ' and ';
        }
      }
      if (hours > 0) {
        result += '$hours hour${hours == 1 ? '' : 's'}';
        if (minutes > 0) {
          result += ' and ';
        }
      }
      if (minutes > 0) {
        result += '$minutes minute${minutes == 1 ? '' : 's'}';
      }

      return result.isEmpty ? 'Just now' : result;
    } catch (e) {
      return 'Invalid date';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.status + ' Applications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif',
          ),
        ),
        backgroundColor: Colors.transparent, // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
           color: Colors.purple
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
             color: Colors.purple
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 50),
            child: ListView.builder(
              itemCount: applicationDataList.length,
              itemBuilder: (context, index) {
                final appData = applicationDataList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appData.application,
                            style: TextStyle(
                              color: Colors.purple,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text('Applicant ID: ',style: TextStyle(color: Colors.purple,fontSize: 20,fontWeight: FontWeight.bold),),
                              Text(appData.applicantId.toString(),style: TextStyle(fontSize: 18),)
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text('Creation Date: ',style: TextStyle(color: Colors.purple,fontSize: 20,fontWeight: FontWeight.bold),),
                              Text(appData.creationDate,style: TextStyle(fontSize: 16),)
                            ],
                          ),
                          Row(
                            children: [
                              Text('Status: ',style: TextStyle(color: Colors.purple,fontSize: 20,fontWeight: FontWeight.bold),),
                              Text(appData.status,style: TextStyle(fontSize: 18),)
                            ],
                          ),
                          Text('Payement Status: ',style: TextStyle(color: Colors.purple,fontSize: 20,fontWeight: FontWeight.bold),),
                          if (appData.payed == 0) TextButton(
                            onPressed: (){
                              print(appData.id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => pay(applicationID: appData.id.toString(),price:2,firstname:widget.firstname,lastname:widget.lastname,userId:widget.userId)),
                              );
                            },
                            child: Text('You Have not completed the payment of this application, press to pay for it',style: TextStyle(fontSize: 18),),
                          ),
                          if (appData.payed == 1) Text('You have completed the payment for the application.',style: TextStyle(fontSize: 18),),
                          if (appData.status.compareTo('rejected') == 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Admin Message: ',style: TextStyle(color: Colors.purple,fontSize: 20,fontWeight: FontWeight.bold),),
                                Text('Reason for Rejecting your application: '+appData.message,style: TextStyle(fontSize: 18),)
                              ],
                            ),
                          if (appData.status.compareTo('accepted') == 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Admin Message: ',style: TextStyle(color: Colors.purple,fontSize: 20,fontWeight: FontWeight.bold),),
                                Text('Estimated time to receive your document: '+calculateTime(appData.Estimated_date),style: TextStyle(fontSize: 18),)
                              ],
                            ),
                          if (appData.status.compareTo('Not Done') == 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Admin Message: ',style: TextStyle(color: Colors.purple,fontSize: 20,fontWeight: FontWeight.bold),),
                                Text('Your application is waiting to be processed by an admin.',style: TextStyle(fontSize: 18))
                              ],
                            ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PrintReport(id: appData.id.toString(),firstname:widget.firstname,lastname:widget.lastname,userId:widget.userId)),
                                );
                              },
                              child: Text('Print Report',style: TextStyle(fontSize: 20,color: Colors.purple),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          navigator.buildNavigator(context, widget.userId, widget.firstname, widget.lastname)
        ],
      ),
    );
  }
}


class ApplicationData {
  final int id;
  final int applicantId;
  final String application;
  final int user_id;
  final String creationDate;
  final String status;
  final String message;
  final String Estimated_date;
  final int payed;
  final String link;

  ApplicationData( {
    required this.id,
    required this.user_id,
    required this.applicantId,
    required this.application,
    required this.creationDate,
    required this.status,
    required this.payed,
    required this.link,
    required this.Estimated_date,
    required this.message
  });

  factory ApplicationData.fromJson(Map<String, dynamic>? json, int index) {
    if (json == null) {
      // Handle null case, such as setting default values
      return ApplicationData(
          id: 0,
          applicantId: 0,
          user_id: 0,
          application: '',
          creationDate: '',
          status: '',
          payed:0,
          link: '',
          Estimated_date:'',
          message: ''
      );
    }
    return ApplicationData(
      id: json['application_id'],
      applicantId: json['ApplicantID'] ?? 0,
      user_id: json['user_id'] ?? 0,
      application: json['application_type'] ?? '',
      creationDate: json['created_at'] ?? '',
      status: json['Status'] ?? '',
      payed:json['payed']??0,
      Estimated_date: json['Estimated_date']??'',
      message: json['message']??'',
      link: 'http://',
    );
  }
}