import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/admin/Notify.dart';
import 'package:graduationprojectweb/screens/admin/applicationprocessing.dart';
import 'package:graduationprojectweb/screens/admin/applications.dart';
import 'package:graduationprojectweb/screens/admin/chat/chatting.dart';
import 'package:graduationprojectweb/screens/admin/dashboardscreen.dart';
import 'package:graduationprojectweb/screens/home.dart';
import 'package:graduationprojectweb/screens/login.dart';
import 'package:graduationprojectweb/screens/user/HomeScreen.dart';
import 'package:http/http.dart' as http;
class Applications extends StatefulWidget {
  const Applications({
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
  State<Applications> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<Applications> {
  int _selectedIndex = 2;
  bool isExpanded = false;
  late int totalApplications;
  late int applicationsLastWeek;
  List<ApplicationData> applicationDataList = [];
  List<ApplicationData> filteredList = [];
  List<ApplicationCount> applicationCounts = [];
  late TextEditingController userIdController;
  String selectedValue = 'all';

  @override
  void initState() {
    super.initState();
    isExpanded = false;
    totalApplications = 0;
    userIdController = TextEditingController();
    applicationsLastWeek = 0;
    fetchData('all');
    fetchTypes();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    userIdController.dispose();
    super.dispose();
  }

  Future<void> fetchTypes() async {
    final response = await http.post(
      Uri.parse('http://$IP/palease_api/applications_type.php'),
      body: {'user_id': widget.userId},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        setState(() {
          applicationCounts = (data['application_counts'] as List)
              .map((item) => ApplicationCount.fromJson(item))
              .toList();
        });
      } else {
        // Handle error
        print('Failed to fetch data: ${data['error']}');
      }
    } else {
      // Handle HTTP error
      print('HTTP error ${response.statusCode}');
    }
  }

  Future<void> fetchData(String? value) async {
    try {
      String uri = "http://$IP/palease_api/application_table.php";
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

            DateTime lastWeek = DateTime.now().subtract(Duration(days: 7));
            applicationsLastWeek = applicationDataList
                .where((app) => DateTime.parse(app.creationDate).isAfter(lastWeek))
                .length;

            totalApplications = applicationDataList.length;
            filteredList=applicationDataList;
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

  void filterByUserId(String userId) {
    setState(() {
      if (userId.isEmpty) {
        // If the search query is empty, show all applications
        // You may want to fetch data again from the server if needed
        fetchData(selectedValue);
      } else {
        // Filter applicationDataList by user ID
        filteredList = applicationDataList.where((app) => app.applicantId.toString() == userId).toList();
      }
    });
  }

  void filterByApplicationType(String applicationType) {
    setState(() {
      if (applicationType.isEmpty) {
        fetchData(selectedValue);
      } else {
         filteredList = applicationDataList
            .where((app) => app.application == applicationType)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.showNotify && widget.showapplications){
      setState(() {
        _selectedIndex=2;
      });
    }else if(widget.showapplications){
      setState(() {
        _selectedIndex=1;
      });
    }
    return Scaffold(
      body: Row(
        children: [
          //Let's start by adding the Navigation Rail
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
            child: Padding(
              padding: EdgeInsets.all(60.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //let's add the navigation menu for this project
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            //let's trigger the navigation expansion
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          icon: Icon(Icons.menu),
                        ),
                        Text(
                          'Welcome, ${widget.firstname} ${widget.lastname}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                          radius: 26.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    //Now let's start with the dashboard main rapports
                    Padding(
                      padding: const EdgeInsets.only(top:40.0),

                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 0),
                        padding: const EdgeInsets.only(right: 5,left:8),
                        height: 300,
                        child: ListView(
                          // This next line does the trick.
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top:10.0,right:50),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.all_inclusive_rounded,
                                            size: 26.0,
                                            color: Secondary,
                                          ),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          Text(
                                            "ALL Applications",
                                            style: TextStyle(
                                              color: primary,
                                              fontSize: 26.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        "${totalApplications} application",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            for (var count in applicationCounts)
                              Padding(
                                padding: const EdgeInsets.only(top:10.0,right:50),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.book_outlined,
                                              size: 26.0,
                                              color: Secondary,
                                            ),
                                            SizedBox(
                                              width: 15.0,
                                            ),
                                            Text(
                                              count.applicationType,
                                              style: TextStyle(
                                                color: primary,
                                                fontSize: 26.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          ' ${count.count} applications',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                              ),
                          ],
                        ),
                      ),
                    ),
                    //Now let's set the article section
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              '$totalApplications Applications',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "$applicationsLastWeek new Applications",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        // Inside your build method:
                        Container(
                          width: 300.0,
                          child: TextField(
                            controller: userIdController,
                            decoration: InputDecoration(
                              hintText: "Search By User ID",
                              prefixIcon: IconButton(
                                icon:Icon(Icons.search),
                                onPressed: (){
                                  filterByUserId(userIdController.text);
                                },),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              // Call a function to filter the applicationDataList

                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40.0,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                DropdownButton(
                                  hint: Text("Filter by"),
                                  items: [
                                    DropdownMenuItem(
                                      value: "all",
                                      child: Text("All"),
                                    ),
                                    DropdownMenuItem(
                                      value: "Not Done",
                                      child: Text("Not Done"),
                                    ),
                                    DropdownMenuItem(
                                      value: "rejected",
                                      child: Text("Rejected"),
                                    ),
                                    DropdownMenuItem(
                                      value: "accepted",
                                      child: Text("Accepted"),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    fetchData(value); // Fetch data based on the selected filter value
                                  },),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    //Now let's add the Table
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Update currentPageEntries based on the current page
                        DataTable(
                          headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.grey.shade200),
                          columns: [
                            DataColumn(label: Text("ID")),
                            DataColumn(label: Text("user ID")),
                            DataColumn(label: Text("Application Type")),
                            DataColumn(label: Text("Creation date")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("link to application")),
                          ],
                          rows: filteredList.map((appData) {
                            return DataRow(
                              cells: [
                                DataCell(Text(appData.id.toString())),
                                DataCell(Text(appData.applicantId.toString())),
                                DataCell(Text(appData.application)),
                                DataCell(Text(appData.creationDate)),
                                DataCell(Text(appData.status)),
                                DataCell(TextButton(
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Application_Processing(applicationID: appData.applicationID,status: appData.status, userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname,applicantID:appData.userID, showNotify: widget.showNotify, showapplications: widget.showapplications,)),
                                    );},

                                  child: Text('view'),
                                ))
                              ],
                            );
                          }).toList(),
                        ),
                        // Pagination controls



                      ],
                    )
                  ],
                ),




              ),
            ),
          ),
        ],
      ),
    );

  }
}


class ApplicationData {
  final int id;
  final int applicantId;
  final String application;
  final int applicationID;
  final String creationDate;
  final String userID;
  final String status;
  final String link;


  ApplicationData( {
    required this.id,
    required this.applicantId,
    required this.applicationID,
    required this.application,
    required this.creationDate,
    required this.userID,
    required this.status,
    required this.link,
  });

  factory ApplicationData.fromJson(Map<String, dynamic> json, int index) {
    return ApplicationData(
      id: index, // Assign ID based on index
      userID: json['user_id'].toString(),
      applicantId: json['ApplicantID'],
      applicationID: json['application_data_id'],
      application: json['application_type'],
      creationDate: json['created_at'],
      status: json['Status'],
      link: 'Show Application',
    );
  }
}

class ApplicationCount {
  final String applicationType;
  final int count;

  ApplicationCount({
    required this.applicationType,
    required this.count,
  });

  factory ApplicationCount.fromJson(Map<String, dynamic> json) {
    return ApplicationCount(
      applicationType: json['application_type'],
      count: json['count'],
    );
  }
}