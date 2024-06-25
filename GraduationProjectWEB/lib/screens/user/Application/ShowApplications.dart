import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/screens/user/payement.dart';
import 'package:graduationprojectweb/screens/user/printreport.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:http/http.dart' as http;
class showapplications extends StatefulWidget {
  showapplications({ required this.userId, required this.firstname, required this.lastname, required this.status, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final String status;
  final bool isEnglish;

  @override
  State<showapplications> createState() => _showapplicationsState();
}

class _showapplicationsState extends State<showapplications> {
  List<ApplicationData> applicationDataList = [];
  late int totalApplications;
  bool isEnglish = true;

  @override
  void initState() {
    super.initState();
    totalApplications = 0;
    isEnglish=widget.isEnglish;
    fetchData(widget.status);
  }
  Future<void> fetchData(String? value) async {
    try {
      String uri = "http://$IP/palease_api/FetchApplications.php";
      var response = await http.post(
        Uri.parse(uri),
        body: {
          "user_id": widget.userId,
          "filter_by": widget.status,
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


  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(context,  isEnglish?'Applications':'الطلبات', widget.userId, widget.firstname, widget.lastname,isEnglish,_toggleLanguage),

      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: ListView.builder(
              itemCount: (applicationDataList.length / 3).ceil(), // Calculate the number of rows needed
              itemBuilder: (context, index) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: index == (applicationDataList.length / 3).ceil() - 1
                      ? applicationDataList.length % 3 // Adjust the last row item count
                      : 3,
                  itemBuilder: (context, innerIndex) {
                    int itemIndex = index * 3 + innerIndex;
                    return buildCard(applicationDataList[itemIndex]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(ApplicationData appData) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(child: Text(appData.application,style: TextStyle(color: Colors.purple,fontSize: 35,fontWeight: FontWeight.bold),)),
            Row(
              children: [
                Text(isEnglish?'Applicant ID: ':'رقم هوية صاحب الطلب',style: TextStyle(color: Colors.purple,fontSize: 25,fontWeight: FontWeight.bold),),
                Text(appData.applicantId.toString(),style: TextStyle(fontSize: 20),)
              ],
            ),
            Row(
              children: [
                Text(isEnglish?'Creation Date: ':'تاريخ تقديم الطلب',style: TextStyle(color: Colors.purple,fontSize: 25,fontWeight: FontWeight.bold),),
                Text(appData.creationDate,style: TextStyle(fontSize: 20),)
              ],
            ),
            Row(
              children: [
                Text(isEnglish?'Status: ':'حالة الطلب',style: TextStyle(color: Colors.purple,fontSize: 25,fontWeight: FontWeight.bold),),
                Text(appData.status,style: TextStyle(fontSize: 20),)
              ],
            ),
                Text(isEnglish?'Payement Status: ':'حالة الدفع',style: TextStyle(color: Colors.purple,fontSize: 25,fontWeight: FontWeight.bold),),
                if (appData.payed == 0) TextButton(
                  onPressed: (){
                    print(appData.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => pay(applicationID: appData.id.toString(),price:2,firstname:widget.firstname,lastname:widget.lastname,userId:widget.userId, isEnglish: isEnglish,)),
                    );
                  },
                  child: Text(isEnglish?'You Have not completed the payment of this application, press to pay for it':'انت لم تكمل عملية الدفع لهذا الطلب، حتى تكمل العملية اضغط هنا',style: TextStyle(fontSize: 20),),
                ),
                if (appData.payed == 1) Text(isEnglish?'You have completed the payment for the application.':'لقد أكملت عملية الدفع لهذا الطلب',style: TextStyle(fontSize: 20),),
            if (appData.status.compareTo('rejected') == 0)
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isEnglish?'Admin Message: ':'رسالة الموظف',style: TextStyle(color: Colors.purple,fontSize: 25,fontWeight: FontWeight.bold),),
                Text(isEnglish?'Reason for Rejecting your application: ':'سبب رفض الطلب'+appData.message,style: TextStyle(fontSize: 20),)
              ],
            ),
            if (appData.status.compareTo('accepted') == 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isEnglish?'Admin Message: ':'رسالة الموظف',style: TextStyle(color: Colors.purple,fontSize: 25,fontWeight: FontWeight.bold),),
                Text(isEnglish?'Estimated time to receive your document: ':'لوقت المقدر حتى تستلم الوثيقة الخاصة بك '+calculateTime(appData.Estimated_date),style: TextStyle(fontSize: 25),)
              ],
            ),
            if (appData.status.compareTo('Not Done') == 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isEnglish?'Admin Message: ':'رسالة الموظف',style: TextStyle(color: Colors.purple,fontSize: 25,fontWeight: FontWeight.bold),),
                Text(isEnglish?'Your application is waiting to be processed by an admin.':'طلبك ما زال ينتظر ان يتم معالجته',style: TextStyle(fontSize: 25))
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
                child: Text(isEnglish?'Get Report':'تنزيل الطلب',style: TextStyle(fontSize: 25,color: Colors.purple),),
              ),
            ),
          ],
        ),
      ),
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