import 'package:flutter/material.dart';
import 'package:graduationproject/Constans/colors.dart';

import 'CentersInfo.dart';
class Deafness extends StatefulWidget {
  Deafness({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  State<Deafness> createState() => _DeafnessState();
}

class _DeafnessState extends State<Deafness> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('deafness', style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent, // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
           color: Colors.purple
          ),
        ),
      ),
      body: Stack(
        children:[
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: const BoxDecoration(
            color: Colors.purple
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(top:0.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'What should we do if we know someone with hearing disconvenious?',
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: primary
                        ),
                      ),
                    ),
                    // Image
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset('assets/deafness.jpg',height: 200,)
                      ),
                    ),
                    // Paragraphs of Information
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deafness:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "Deafness or hearing loss can present communication barriers, but with the right support and accommodations, individuals who are deaf or hard of hearing can thrive. Communication is key, and various methods, including sign language, lip-reading, and assistive devices, can facilitate interaction and understanding. Emphasizing inclusivity and providing access to resources and services tailored to the needs of the deaf community can promote equality and participation.",
                            textAlign: TextAlign.justify,style: TextStyle(fontSize: 16.0,fontFamily: 'SansSerif'),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'General advice:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '-Offer sign language interpretation services and provide communication access in various settings.\n'
                                '-Implement visual alerts and technologies like captioning and assistive listening devices.\n'
                                '-Foster communication strategies that accommodate diverse needs and preferences.\n'
                                '-Promote deaf culture and awareness to reduce stigma and promote inclusion.\n',
                            style: TextStyle(fontSize: 16.0,fontFamily: 'SansSerif'),
                          ),
                          SizedBox(height: 16.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=>CentersInfoPage(userId: widget.userId,firstname:widget.firstname, lastname:widget.lastname,id:2))
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Browse Centers',
                                    style: TextStyle(color: Color.fromRGBO(76, 72, 157, 1)),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.chevron_right, color: Secondary),
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
            ),
          ),
        ],
      ),
    );
  }
}
