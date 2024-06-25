import 'package:flutter/material.dart';
import 'package:graduationprojectweb/Constans/API.dart';
import 'package:graduationprojectweb/screens/user/Driving/driving.dart';
import 'package:graduationprojectweb/screens/user/Education/UniversityData.dart';
import 'package:graduationprojectweb/screens/user/Education/schools.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/CentersInfo.dart';
import 'package:graduationprojectweb/screens/user/HealthCare/form.dart';
import 'package:graduationprojectweb/screens/user/ID/ID.dart';
import 'package:graduationprojectweb/screens/user/Orphanages/orphanageinfo.dart';
import 'package:graduationprojectweb/screens/user/Passport/passport.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  final bool isEnglish;
  final String userId;
  final String firstname;
  final String lastname;

  SearchPage({
    required this.isEnglish,
    required this.userId,
    required this.firstname,
    required this.lastname,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _results = [];
  String _errorMessage = '';
  bool isEnglish = true;
  String _selectedFilter = 'All';

  final Map<String, String> _filterOptions = {
    'All': 'الكل',
    'Application': 'طلبات',
    'School': 'مدارس',
    'University': 'جامعات',
    'Orphanage': 'مراكز ايتام',
    'Needs Center': 'مراكز ذوي احتياجات خاصة',
    'Needs': 'احتياجات خاصة',
  };

  @override
  void initState() {
    super.initState();
    isEnglish = widget.isEnglish;
  }

  Future<void> _performSearch(String query) async {
    final String uri = "http://$IP/palease_api/search.php?query=$query";
    try {
      var response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody is List) {
          setState(() {
            _results = responseBody;
            print(responseBody);
            _errorMessage = '';
          });
        } else if (responseBody is Map && responseBody.containsKey('error')) {
          setState(() {
            _errorMessage = responseBody['error'];
          });
        } else {
          setState(() {
            _errorMessage = 'Unexpected response format';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to load search results: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        print(e);
        _errorMessage = 'Error: $e';
      });
    }
  }

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(
        context,
        isEnglish ? 'Search' : 'البحث',
        widget.userId,
        widget.firstname,
        widget.lastname,
        isEnglish,
        _toggleLanguage,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterDropdown(),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
          _buildResultsList(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: isEnglish ? 'Search...' : 'ابحث',
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              await _performSearch(_searchController.text);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: _selectedFilter,
        onChanged: (String? newValue) {
          setState(() {
            _selectedFilter = newValue!;
          });
        },
        items: _filterOptions.entries.map<DropdownMenuItem<String>>((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text(isEnglish ? entry.key : entry.value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResultsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final result = _results[index];
          if (_selectedFilter != 'All' && result['type'] != _selectedFilter) {
            return Container(); // Skip the item if it doesn't match the filter
          }
          return ListTile(
            title: Text(result['name'],style: TextStyle(color: Colors.purple,fontSize: 20),),
            subtitle: Text(result['type'],style: TextStyle(color: Colors.black,fontSize: 15),),
            onTap: () => _navigateToDetailPage(result),
          );
        },
      ),
    );
  }

  void _navigateToDetailPage(dynamic result) {
    if (result['type'] == 'Application') {
      _navigateToApplication(result['id']);
    } else if (result['type'] == 'School') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Schools(
            userId: widget.userId,
            firstname: widget.firstname,
            lastname: widget.lastname,
            isEnglish: isEnglish,
          ),
        ),
      );
    } else if (result['type'] == 'University') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UniversitiesData(
            userId: widget.userId,
            firstname: widget.firstname,
            lastname: widget.lastname,
            name: result['name'],
            isEnglish: isEnglish,
          ),
        ),
      );
    } else if (result['type'] == 'Orphanage') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => orphanagedata(
            id: result['id'],
            userId: widget.userId,
            firstname: widget.firstname,
            lastname: widget.lastname,
            isEnglish: isEnglish,
          ),
        ),
      );
    } else if (result['type'] == 'Needs Center') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SpecialNeedsForm(
            id: result['RoleID'],
            userId: widget.userId,
            firstname: widget.firstname,
            lastname: widget.lastname,
            isEnglish: isEnglish,
          ),
        ),
      );
    } else if (result['type'] == 'Needs') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CentersInfoPage(
            id: result['id'],
            userId: widget.userId,
            firstname: widget.firstname,
            lastname: widget.lastname,
            isEnglish: isEnglish,
          ),
        ),
      );
    }
  }

  void _navigateToApplication(String id) {
    Widget page;
    switch (id) {
      case '1':
      case '3':
      case '4':
        page = ID(
          userId: widget.userId,
          firstname: widget.firstname,
          lastname: widget.lastname,
          isEnglish: isEnglish,
        );
        break;
      case '2':
      case '7':
      case '8':
        page = Passport(
          userId: widget.userId,
          firstname: widget.firstname,
          lastname: widget.lastname,
          isEnglish: isEnglish,
        );
        break;
      case '9':
      case '10':
        page = driving(
          userId: widget.userId,
          firstname: widget.firstname,
          lastname: widget.lastname,
          isEnglish: isEnglish,
        );
        break;
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
