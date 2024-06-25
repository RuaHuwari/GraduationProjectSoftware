import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/Constans/colors.dart';
import 'package:graduationprojectweb/screens/admin/Notify.dart';
import 'package:graduationprojectweb/screens/admin/applicationprocessing.dart';
import 'package:graduationprojectweb/screens/admin/applications.dart';
import 'package:graduationprojectweb/screens/admin/chat/chatting.dart';
import 'package:graduationprojectweb/screens/home.dart';
import 'package:graduationprojectweb/screens/login.dart';
import 'package:graduationprojectweb/screens/user/HomeScreen.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen(
      {required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool isExpanded = false;
  late Future<String> _departmentType;
  late int totalApplications;
  late int applicationsLastWeek;
  List<ApplicationData> applicationDataList = [];
  List<ApplicationData> filteredList = [];
  List<ApplicationCount> applicationCounts = [];
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _aboutController;
  late TextEditingController _typeController;
  late TextEditingController _governateController;
  late TextEditingController _namearabicController;
  late Future<Map<String, dynamic>> _universityData;
  late TextEditingController _newMajorNameController;
  late TextEditingController _newGpaRequirementController;
  late TextEditingController _newHighSchoolTypeController;
  late TextEditingController _aboutArabicController;
  late TextEditingController _DonationController;
  late TextEditingController _SponserController;
  late int _centerId;
  bool _isLoading = true;
  String name='';
  @override
  void initState() {
    super.initState();
    isExpanded = false;
    totalApplications = 0;
    applicationsLastWeek = 0;
    _departmentType = fetchDepartmentType(widget.userId);
    fetchData('all');
    _fetchCenterData();
    _fetchSchoolData();
    _universityData = fetchUniversityData(widget.userId);
    _newMajorNameController = TextEditingController();
    _newGpaRequirementController = TextEditingController();
    _newHighSchoolTypeController = TextEditingController();
    _fetchOrphanageData();
  }
  Future<void> _fetchOrphanageData() async {
    final response = await http.get(Uri.parse('http://$IP/palease_api/getorphanageinfo.php?user_id=${widget.userId}'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _nameController = TextEditingController(text: data['name']);
        name=data['name'];
        _governateController = TextEditingController(text: data['Governate']);
        _phoneController = TextEditingController(text: data['Phone'].toString());
        _emailController = TextEditingController(text: data['email']);
        _aboutController = TextEditingController(text: data['about_eng']);
        _aboutArabicController = TextEditingController(text: data['about_arabic']);
        _DonationController = TextEditingController(text: data['Donation']);
        _SponserController = TextEditingController(text: data['sponser_an_orphan']);
        print(json.decode(response.body));
        _isLoading = false;
      });
    } else {
      print(json.decode(response.body));
    }
  }

  Future<void> _updateOrphanageData() async {
    final response = await http.post(
      Uri.parse('http://$IP/palease_api/updateorphanageinfo.php'),
      body: {
        'user_id': widget.userId.toString(),
        'name': _nameController.text,
        'Governate': _governateController.text,
        'Phone': _phoneController.text,
        'email': _emailController.text,
        'about_eng': _aboutController.text,
        'about_arabic': _aboutArabicController.text,
        'Donation': _DonationController.text,
        'sponser_an_orphan': _SponserController.text,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        // Show success message
      } else {
        // Show error message
      }
    } else {
      // Handle error
    }
  }
  Future<Map<String, dynamic>> fetchUniversityData(String userId) async {
    final response = await http.get(Uri.parse('http://$IP/palease_api/getuniversitydata.php?user_id=$userId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load university data');
    }
  }

  Future<void> addMajor(String universityId, String majorName, String gpaRequirement, String highSchoolType) async {
    final response = await http.post(
      Uri.parse('http://$IP/palease_api/add_major.php'),
      body: {
        'university_id': universityId,
        'major_name': majorName,
        'gpa_requirement': gpaRequirement,
        'high_school_type': highSchoolType,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _universityData = fetchUniversityData(widget.userId);
      });
    } else {
      throw Exception('Failed to add major');
    }
  }

  Future<void> updateMajor(String majorId, String gpaRequirement, String highSchoolType) async {
    final response = await http.post(
      Uri.parse('http://$IP/palease_api/update_major.php'),
      body: {
        'major_id': majorId,
        'gpa_requirement': gpaRequirement.toString(),
        'high_school_type': highSchoolType.toString(),
      },
    );

    if (response.statusCode == 200) {

    } else {
      throw Exception('Failed to update major');
    }
  }

  Future<void> deleteMajor(String majorId) async {
    final response = await http.post(
      Uri.parse('http://$IP/palease_api/delete_major.php'),
      body: {'major_id': majorId},
    );

    if (response.statusCode == 200) {

    } else {
      throw Exception('Failed to delete major');
    }
  }

  Future<void> _fetchSchoolData() async {
    final response = await http.get(Uri.parse('http://$IP/palease_api/getschoolsinfo.php?user_id=${widget.userId}'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _nameController = TextEditingController(text: data['schoolname']);
        name=data['schoolname'];
        _namearabicController = TextEditingController(text: data['schoolname_arabic']);
        _governateController = TextEditingController(text: data['governate']);
        _phoneController = TextEditingController(text: data['phonenumber'].toString());
        _typeController = TextEditingController(text: data['type']);
        _aboutController = TextEditingController(text: data['about']);
        print(json.decode(response.body));
        _isLoading = false;
      });
    } else {
      print(json.decode(response.body));
    }
  }

  Future<void> _updateSchoolData() async {
    final response = await http.post(
      Uri.parse('http://$IP/palease_api/updateschoolinfo.php'),
      body: {
        'user_id': widget.userId.toString(),
        'schoolname': _nameController.text,
        'schoolname_arabic': _namearabicController.text,
        'phonenumber': _phoneController.text,
        'type': _typeController.text,
        'about': _aboutController.text,
        'governate': _governateController.text,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        // Show success message
      } else {
        // Show error message
      }
    } else {
      // Handle error
    }
  }
  Future<void> _fetchCenterData() async {
    final response = await http.get(Uri.parse('http://$IP/palease_api/getcentersinfo.php?user_id=${widget.userId}'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _nameController = TextEditingController(text: data['centername']);
        _addressController = TextEditingController(text: data['Address']);
        _phoneController = TextEditingController(text: data['phonenumber'].toString());
        _emailController = TextEditingController(text: data['email']);
        _aboutController = TextEditingController(text: data['about']);
        print(json.decode(response.body));
        _isLoading = false;
      });
    } else {
      print(json.decode(response.body));
    }
  }

  Future<void> _updateCenterData() async {
    final response = await http.post(
      Uri.parse('http://$IP/palease_api/updatecenterinfo.php'),
      body: {
        'user_id': widget.userId.toString(),
        'centername': _nameController.text,
        'Address': _addressController.text,
        'phonenumber': _phoneController.text,
        'email': _emailController.text,
        'about': _aboutController.text,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        // Show success message
      } else {
        // Show error message
      }
    } else {
      // Handle error
    }
  }
  Future<void> fetchData(String? value) async {
    try {
      String uri = "http://$IP/palease_api/application_table.php";
      var response = await http.post(
        Uri.parse(uri),
        body: {
          "user_id": widget.userId.toString(),
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
            filteredList = applicationDataList;
          });
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

  Future<String> fetchDepartmentType(String userId) async {
    final response = await http.get(
      Uri.parse('http://$IP/palease_api/Get_department_type.php?id=$userId'),
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      if (responseBody.isNotEmpty) {
        print(responseBody[0].toString());
        if(responseBody[0].toString()=='1'){
          setState(() {
            showNotify=true;
            showapplication=true;
          });
        }else if(responseBody[0].toString()=='2'){
          setState(() {
            showapplication=true;
          });
        }
        return responseBody[0].toString();
      } else {
        throw Exception('No department type found');
      }
    } else {
      throw Exception('Failed to load department type');
    }
  }

  Map<String, int> getApplicationTypeCounts() {
    Map<String, int> applicationTypeCounts = {};
    for (var application in applicationDataList) {
      if (applicationTypeCounts.containsKey(application.application)) {
        applicationTypeCounts[application.application] =
            applicationTypeCounts[application.application]! + 1;
      } else {
        applicationTypeCounts[application.application] = 1;
      }
    }
    return applicationTypeCounts;
  }

  Map<String, int> getApplicationCountsByDate() {
    Map<String, int> applicationCountsByDate = {};
    for (var application in applicationDataList) {
      String date = application.creationDate.split(' ')[0]; // Extracting date part
      if (applicationCountsByDate.containsKey(date)) {
        applicationCountsByDate[date] = applicationCountsByDate[date]! + 1;
      } else {
        applicationCountsByDate[date] = 1;
      }
    }
    return applicationCountsByDate;
  }

  List<PieChartSectionData> generatePieChartSections() {
    Map<String, int> data = getApplicationTypeCounts();
    final List<Color> colors = [
      Colors.deepPurple.withOpacity(1),
      Colors.deepPurple.withOpacity(0.6),
      Colors.deepPurple.withOpacity(0.3),

      Colors.purpleAccent,
    ];

    int colorIndex = 0;
    return data.entries.map((entry) {
      final color = colors[colorIndex % colors.length];
      colorIndex++;
      return PieChartSectionData(
        color: color,
        value: entry.value.toDouble(),
        title: '${entry.key}: ${entry.value}',
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      );
    }).toList();
  }

  Widget buildApplicationTypePieChart() {
    return SizedBox(
      height: 300,
      width: 300,
      child: PieChart(

        PieChartData(
          sections: generatePieChartSections(),
          sectionsSpace: 3,
          centerSpaceRadius: 80,

          borderData: FlBorderData(show: false),
          pieTouchData: PieTouchData(touchCallback: (FlTouchEvent, pieTouchResponse) {
            // Handle touch interactions if needed
          }),
        ),
      ),
    );
  }

  Widget buildApplicationDistributionLineChart() {
    // Get the data
    Map<String, int> data = getApplicationCountsByDate();

    // Calculate the date 30 days ago from now
    DateTime today = DateTime.now();
    DateTime oneMonthAgo = today.subtract(Duration(days: 30));

    // Filter the data to include only entries from the last month
    data = data.entries
        .where((entry) => DateTime.parse(entry.key).isAfter(oneMonthAgo))
        .fold<Map<String, int>>({}, (map, entry) {
      map[entry.key] = entry.value;
      return map;
    });

    // Map the data to spots and sort them
    List<FlSpot> spots = data.entries.map((entry) {
      DateTime date = DateTime.parse(entry.key);
      return FlSpot(date.millisecondsSinceEpoch.toDouble(), entry.value.toDouble());
    }).toList();
    spots.sort((a, b) => a.x.compareTo(b.x));

    // Build the chart
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            color: Colors.deepPurple,
            barWidth: 4,
            belowBarData: BarAreaData(show: true, color: Colors.deepPurple.withOpacity(0.3)),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return Text("${date.day}/${date.month}");
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: true),
        minY: 0,
      ),
    );
  }

  bool showNotify=false;
  bool showapplication=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              if(showNotify)
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart),
                label: Text("Notify Users"),
              )
              ,if(showapplication)
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
                  if(showNotify)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Notify(
                              userId: widget.userId,
                              firstname: widget.firstname,
                              lastname: widget.lastname,showNotify:true,showapplications:true)),
                    );
                  else if(showapplication){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Applications(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname,showNotify:showNotify,showapplications:showapplication)),
                    );
                  }
                  else    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname,showNotify:showNotify,showapplications:showapplication)),
                  );
                    break;
                  case 2:
                    if(showNotify && showapplication)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Applications(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname,showNotify:showNotify,showapplications:showapplication)),
                    );
                    else if(showapplication)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname,showNotify:showNotify,showapplications:showapplication)),
                      );
                    else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const home()),
                      );
                    }
                    break;
                  case 3:
                    if(showNotify && showapplication)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname,showNotify:showNotify,showapplications:showapplication)),
                    );
                    else if(showapplication){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const home()),
                      );
                    }
                    break;
                  case 4:
                    if(showNotify&& showapplication)
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
          FutureBuilder<String>(
            future: _departmentType,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                String departmentType = snapshot.data!;
                String departmentname='';
                if(departmentType=='1' || departmentType=='2')
                 departmentname=applicationDataList.first.departmentname;
                print(departmentname);
                if (departmentType == '1')
                { //Governmetn Services

                  return Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              departmentname+' Department',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 40,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Dashboard",
                              style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold,color: Colors.deepPurpleAccent),
                            ),
                            SizedBox(height: 40.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                 Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Total Applications: $totalApplications',
                                        style: TextStyle(fontSize: 25.0),
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        'Applications in Last Week: $applicationsLastWeek',
                                        style: TextStyle(fontSize: 25.0),
                                      ),
                                      SizedBox(height: 16.0),

                                    ],
                                  ),
                                SizedBox(width: 460,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Application Types Distribution',
                                      style: TextStyle(fontSize: 25.0),
                                    ),
                                    buildApplicationTypePieChart(),
                                  ],
                                ),

                              ],
                            ),
                            SizedBox(height: 32.0), // Adds space between the Row and the line chart
                            Text(
                              'Application Distribution Over Time',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            SizedBox(height: 8.0),
                            SizedBox(
                              height: 300,
                              child: buildApplicationDistributionLineChart(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                else if(departmentType=='2'){//Special Needs Center
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              departmentname+' Center',
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(
                              height: 20
                            ),
                            Text(
                              "Dashboard",
                              style:
                              TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold, color:Colors.deepPurpleAccent),
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Total Applications: $totalApplications',
                                  style: TextStyle(fontSize: 25.0,color: Colors.deepPurpleAccent.withOpacity(0.5)),
                                ),
                                SizedBox(width: 16.0),
                                Text(
                                  'Applications in Last Week: $applicationsLastWeek',
                                  style: TextStyle(fontSize: 25.0,color: Colors.deepPurpleAccent.withOpacity(0.5)),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Application Distribution Over Time',
                              style: TextStyle(fontSize: 25.0),
                            ),
                            SizedBox(
                              height:20
                            ),
                            SizedBox(
                              height: 300,
                              child: buildApplicationDistributionLineChart(),
                            ),
                        SizedBox(
                          height:20
                        ),
                        _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _nameController,
                                      decoration: InputDecoration(labelText: 'Center Name'),
                                    ),
                                  ),
                                  SizedBox(width: 25.0),
                                  Expanded(
                                    child: TextField(
                                      controller: _addressController,
                                      decoration: InputDecoration(labelText: 'Center Address'),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 26.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _phoneController,
                                      decoration: InputDecoration(labelText: 'Phone Number'),
                                    ),
                                  ),
                                  SizedBox(width: 25.0),
                                  Expanded(
                                    child: TextField(
                                      controller: _emailController,
                                      decoration: InputDecoration(labelText: 'Email'),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 26.0),
                              TextField(
                                controller: _aboutController,
                                decoration: InputDecoration(labelText: 'About'),
                                maxLines: 4, // Set the maxLines to make it a multiline text area
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _updateCenterData,
                                child: Text('Update'),
                              ),
                            ],
                          ),
                        )

                        ],
                        ),
                      ),
                    ),
                  );
                }else if(departmentType=='3'){//Schools
                  return Expanded(child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 40,
                          fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height:30),
                        Text('School Info:',style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold, fontSize: 30),),
                        SizedBox(height:30),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _nameController,
                                decoration: InputDecoration(labelText: 'School Name'),
                              ),
                            ),
                            SizedBox(width: 26.0),
                            Expanded(
                              child: TextField(
                                controller: _namearabicController,
                                decoration: InputDecoration(labelText: 'School Name Arabic'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 26.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _governateController,
                                decoration: InputDecoration(labelText: 'Governate'),
                              ),
                            ),
                            SizedBox(width: 26.0),
                            Expanded(
                              child: TextField(
                                controller: _typeController,
                                decoration: InputDecoration(labelText: 'Type'),
                              ),
                            ),
                            SizedBox(width: 26.0),
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                decoration: InputDecoration(labelText: 'Phone Number'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 26.0),
                        TextField(
                          controller: _aboutController,
                          decoration: InputDecoration(labelText: 'About'),
                          maxLines: 4, // Set the maxLines to make it a multiline text area
                        ),
                        SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: _updateSchoolData,
                            child: Text('Update'),
                          ),
                        ),
                      ],
                    ),
                  )

                  );
                }else if (departmentType == '4') {// Universities
                  return Expanded(
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: _universityData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          var university = snapshot.data!['university'];
                          var majors = snapshot.data!['majors'];

                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${university['name']}',
                                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                                  ),
                                  Text(
                                    '${university['name_arabic']}',
                                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),
                                    textAlign: TextAlign.right,
                                  ),
                                  SizedBox(height: 30),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Governate:',
                                        style: TextStyle(color: Colors.deepPurple, fontSize: 30, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '${university['governate']}',
                                        style: TextStyle(fontSize: 23),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'About:',
                                        style: TextStyle(color: Colors.deepPurple, fontSize: 30, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          '${university['About']}',
                                          style: TextStyle(fontSize: 23),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${university['About_Arabic']}',
                                          style: TextStyle(fontSize: 23),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        ':حول الجامعة',
                                        style: TextStyle(color: Colors.deepPurple, fontSize: 30, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Application Link: ${university['link']}',
                                      style: TextStyle(fontSize: 26, color: Colors.deepPurpleAccent),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Center(
                                    child: Text(
                                      'Majors:',
                                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  DataTable(
                                    columns: [
                                      DataColumn(label: Text('Major Name', style: TextStyle(color: Colors.deepPurple))),
                                      DataColumn(label: Text('GPA Requirement', style: TextStyle(color: Colors.deepPurple))),
                                      DataColumn(label: Text('High School Type', style: TextStyle(color: Colors.deepPurple))),
                                      DataColumn(label: Text('Actions', style: TextStyle(color: Colors.deepPurple))),
                                    ],
                                    rows: majors.map<DataRow>((major) {
                                      TextEditingController gpaController = TextEditingController(text: major['gpa_requirement']);
                                      TextEditingController highSchoolController = TextEditingController(text: major['high_school_type']);

                                      return DataRow(cells: [
                                        DataCell(Text(major['name'])),
                                        DataCell(
                                          TextFormField(
                                            controller: gpaController,
                                            decoration: InputDecoration(border: InputBorder.none),
                                          ),
                                        ),
                                        DataCell(
                                          TextFormField(
                                            controller: highSchoolController,
                                            decoration: InputDecoration(border: InputBorder.none),
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.save, color: Colors.deepPurple),
                                                onPressed: () {
                                                  updateMajor(major['id'].toString(), gpaController.text, highSchoolController.text);
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete, color: Colors.deepPurple),
                                                onPressed: () {
                                                  deleteMajor(major['id'].toString());
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]);
                                    }).toList(),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Add New Major:',
                                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.deepPurple),
                                  ),
                                  TextFormField(
                                    controller: _newMajorNameController,
                                    decoration: InputDecoration(labelText: 'Major Name'),
                                  ),
                                  TextFormField(
                                    controller: _newGpaRequirementController,
                                    decoration: InputDecoration(labelText: 'GPA Requirement'),
                                  ),
                                  TextFormField(
                                    controller: _newHighSchoolTypeController,
                                    decoration: InputDecoration(labelText: 'High School Type'),
                                  ),
                                  SizedBox(height: 10),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        addMajor(university['id'], _newMajorNameController.text, _newGpaRequirementController.text, _newHighSchoolTypeController.text);
                                      },
                                      child: Text('Add Major',style: TextStyle(fontSize: 30),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                }
              else if(departmentType=='5'){

                  return Expanded(child:_isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 40,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _nameController,
                                decoration: InputDecoration(labelText: 'Orphanage Name'),
                              ),
                            ),
                            SizedBox(width: 26),
                            Expanded(
                              child: TextField(
                                controller: _governateController,
                                decoration: InputDecoration(labelText: 'Governate'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                decoration: InputDecoration(labelText: 'Phone Number'),
                              ),
                            ),
                            SizedBox(width: 26),
                            Expanded(
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(labelText: 'Email'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        TextField(
                          controller: _aboutController,
                          decoration: InputDecoration(labelText: 'About'),
                          maxLines: null,  // Allow multiline input
                        ),
                        SizedBox(height: 30),
                        TextField(
                          controller: _aboutArabicController,
                          decoration: InputDecoration(labelText: 'About Arabic'),
                          maxLines: null,  // Allow multiline input
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _DonationController,
                                decoration: InputDecoration(labelText: 'Donation Link'),
                              ),
                            ),
                            SizedBox(width: 26),
                            Expanded(
                              child: TextField(
                                controller: _SponserController,
                                decoration: InputDecoration(labelText: 'Sponser An Orphan'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _updateOrphanageData,
                          child: Text('Update', style: TextStyle(fontSize: 30),),
                        ),
                      ],
                    ),
                  )

                  );// Return an empty container if not department type 1 or 2
                }else{
                  return Container();
                }
              }
            },
          ),

        ],
      ),
    );
  }
}

class ApplicationData {
  final int id;
  final String userId;
  final String departmentId;
  final String departmentname;
  final String application;
  final String applicationStatus;
  final String creationDate;

  ApplicationData(
     {  required this.departmentname,
    required this.id,
    required this.userId,
    required this.departmentId,
    required this.application,
    required this.applicationStatus,
    required this.creationDate,
  });

  factory ApplicationData.fromJson(Map<String, dynamic> json, int id) {
    return ApplicationData(
      id: id,
      userId: json['user_id'].toString(),
      departmentId: json['department_id'].toString(),
      application: json['application_type'],
      applicationStatus: json['Status'],
      creationDate: json['created_at'],
      departmentname: json['department_name'],
    );
  }
}

class ApplicationCount {
  final String department;
  final int count;

  ApplicationCount({
    required this.department,
    required this.count,
  });

  factory ApplicationCount.fromJson(Map<String, dynamic> json) {
    return ApplicationCount(
      department: json['department'],
      count: json['count'],
    );
  }
}
