import 'package:flutter/material.dart';
import 'package:graduationproject/Constans/colors.dart';

import 'CentersInfo.dart';
class Mental extends StatefulWidget {
  Mental({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  State<Mental> createState() => _MentalState();
}

class _MentalState extends State<Mental> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mental Health And Emotional Well-being', style: TextStyle(
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
                        'What should we do if we know someone with Mental Health or emotional issues?',
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
                          child: Image.asset('assets/mentalhealth.png',height: 200,)
                      ),
                    ),
                    // Paragraphs of Information
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mental Health and Emotional Well-being',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "Mental health conditions, such as depression, anxiety disorders, bipolar disorder, and schizophrenia, as well as emotional challenges, are prevalent and can significantly impact an individual's well-being and quality of life. It's crucial to recognize the importance of mental health and provide access to comprehensive support and treatment services. With early intervention, therapy, medication management, and community support, individuals experiencing mental health challenges can achieve recovery, resilience, and overall well-being.",
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
                            "-Promote mental health awareness and reduce stigma through education and advocacy efforts.\n"
                                '-Provide access to counseling, therapy, and psychiatric services for assessment and treatment.\n'
                                '-Foster supportive communities and peer support networks for individuals experiencing mental health challenges.\n'
                                '-Encourage self-care practices, stress management techniques, and healthy coping strategies to promote emotional well-being.\n',
                            style: TextStyle(fontSize: 16.0,fontFamily: 'SansSerif'),
                          ),
                          SizedBox(height: 16.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=>CentersInfoPage(userId: widget.userId,firstname:widget.firstname, lastname:widget.lastname,id:6))
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
