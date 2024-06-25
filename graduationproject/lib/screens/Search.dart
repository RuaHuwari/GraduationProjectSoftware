import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:graduationproject/Constans/API.dart';
import 'package:graduationproject/screens/Applications/Applications.dart';
import 'package:graduationproject/screens/ID_Field/IDs.dart';
import '../Constans/colors.dart';
import '../Models/users.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';

import '../widgets/CusomButton.dart';
import '../widgets/CustomCategorisList.dart';
import '../widgets/CustomSlider.dart';
import '../widgets/CustomTextField.dart';
import 'Education/Education.dart';
import 'HomeScreen.dart';
import 'Passport/passport.dart';
class SearchScreen extends StatefulWidget {
  final String userId;
  final String firstname;
  final String lastname;
  SearchScreen({required this.userId, required this.firstname,required this.lastname});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  static List previousSearchs = [];
  @override
  void initState() {
    super.initState();
    fetchSearchHistory();
  }
  Future<void> fetchSearchHistory() async {
    try {
      String uri = "http://$IP/palease_api/fetch_history.php";
      var res = await http.post(Uri.parse(uri), body: {
        "id": '407489830',
      });

      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['success'] == 'true') {
          setState(() {
            previousSearchs = List<String>.from(data['data']);
          });
          print('Search history fetched successfully');
        } else {
          print('Failed to fetch search history: ${data['error']}');
        }
      } else {
        print('Failed to fetch search history: HTTP request failed with status ${res.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch search history: $e');
    }
  }

  Future<void> saveSearchHistory(String id, String history) async {
    final response = await http.post(
      Uri.parse('http://$IP/palease_api/inser_history.php'),
      body: {
        'id': id,
        'history': history,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == 'true') {
        // Successfully saved search history
        print('Search history saved successfully');
      } else {
        // Failed to save search history
        print('Failed to save search history');
      }
    } else {
      // HTTP request failed
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
               color:Colors.purple
              ),
              child: ListView(
                children: [
                  Column(
                    children: [
                      // Search Bar
                      Container(
                        //color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: mainText,
                                  )),
                              Expanded(
                                child: CostomTextFormFild(
                                  hint: "Search",
                                  prefixIcon: Icons.search,
                                  controller: searchController,
                                  filled: true,
                                  suffixIcon: searchController.text.isEmpty
                                      ? null
                                      : Icons.cancel_sharp,
                                  onTapSuffixIcon: () {
                                    searchController.clear();
                                  },
                                  onChanged: (pure) { //suggestion for search
                                    setState(() {});
                                  },
                                  onEditingComplete: () async { //edit this code to have the results of the search
                                    await saveSearchHistory('407489830', searchController.text);
                                    previousSearchs.add(searchController.text);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>  SearchScreen(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)));
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(25),
                                            ),
                                          ),
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          context: context,
                                          builder: (context) =>
                                              _custombottomSheetFilter(context));
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.filter_alt_outlined,
                                    color: mainText,
                                  )),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      // Previous Searches
                      Container(
                        //color: Colors.white,
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: previousSearchs.length,
                            itemBuilder: (context, index) => previousSearchsItem(index)),
                      ),
                      const SizedBox(
                        height: 8,
                      ),

                      // Search Suggestions
                      Container(

                        decoration:  BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: primary.withOpacity(0.3),
                        ),
                        padding: const EdgeInsets.only(left:30,right:30,top:30,bottom:30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Search Suggestions",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35
                              ),

                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              children: [
                                searchSuggestionsTiem("Education",Education(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname)),
                                searchSuggestionsTiem("IDs",ID(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname,)),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                searchSuggestionsTiem("Passports",Passport(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname)),
                                searchSuggestionsTiem("Apllication",applications(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname)),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  previousSearchsItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.only(top:5,bottom:5,left: 20,right: 20),
        decoration: BoxDecoration(
            color:  Secondary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20)
        ),
        child: InkWell(
          onTap: () {},
          child: Dismissible(
            key: GlobalKey(),
            onDismissed: (DismissDirection dir) {
              setState(() {});
              previousSearchs.removeAt(index);
            },
            child: Container(

              child: Row(

                children: [
                  const Icon(
                    Icons.access_time,
                    color: primary,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    previousSearchs[index],
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.black),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.call_made_outlined,
                    color: SecondaryText,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  searchSuggestionsTiem(String text,Widget page) {
    return Container(
      margin: EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration:
      BoxDecoration(color: form, borderRadius: BorderRadius.circular(30)),
      child: GestureDetector(
        onTap: (){  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );},
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color:primary),
        ),
      ),
    );
  }

  _custombottomSheetFilter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 500,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Add a Filter",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          CustomCategoriesList(),
          CustomSlider(),
          Row(
            children: [
              Expanded(
                  child: CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: "Cancel",
                    color: form,
                    textColor: mainText,
                  )),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: CustomButton(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(userId: widget.userId, firstname: widget.firstname, lastname: widget.lastname),
                          ));
                    },
                    text: "Done",
                  ))
            ],
          )
        ],
      ),
    );
  }
}