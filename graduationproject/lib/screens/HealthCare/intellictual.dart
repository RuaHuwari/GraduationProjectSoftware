import 'package:flutter/material.dart';
import 'package:graduationproject/Constans/colors.dart';

import 'CentersInfo.dart';
class Intellectual extends StatefulWidget {
  Intellectual({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  State<Intellectual> createState() => _IntellectualState();
}

class _IntellectualState extends State<Intellectual> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Intellectual Disability', style: TextStyle(
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
                        'What should we do if we know someone with Intellectual Disability?',
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
                          child: Image.asset('assets/Intellectualdisability.jpg',height: 200,)
                      ),
                    ),
                    // Paragraphs of Information
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Intellectual Disability:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "Intellectual disability refers to limitations in intellectual functioning and adaptive behavior, which may impact learning, communication, and daily living skills. However, it's important to recognize the diverse strengths and abilities of individuals with intellectual disabilities and provide the necessary support and accommodations to help them succeed. Access to education, vocational training, social support, and community services can empower individuals with intellectual disabilities to lead fulfilling lives and contribute to society.",
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
                            "-Provide individualized support and accommodations based on each person's strengths and needs.\n"
                                '-Offer inclusive educational programs and vocational training opportunities.\n'
                                '-Foster social inclusion and peer support networks to promote friendship and belonging.\n'
                                '-Advocate for policies and practices that promote the rights and inclusion of individuals with intellectual disabilities.\n',
                            style: TextStyle(fontSize: 16.0,fontFamily: 'SansSerif'),
                          ),
                          SizedBox(height: 16.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=>CentersInfoPage(userId: widget.userId,firstname:widget.firstname, lastname:widget.lastname,id:4))
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
