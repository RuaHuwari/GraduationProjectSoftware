import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Constans/colors.dart';
import 'package:graduationproject/screens/Driving/driving.dart';
import 'package:graduationproject/screens/Driving/licenseform.dart';

class Newlicense extends StatefulWidget {
  Newlicense({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  _newlicensePageState createState() => _newlicensePageState();
}

class _newlicensePageState extends State<Newlicense> {
  int _selectedOption = 0;

  void _handleRadioValueChanged(int value) {
    setState(() {
      _selectedOption = value;
    });
  }

  void _navigateToForm(BuildContext context) {
    switch (_selectedOption) {
      case 0:
      // Navigate to Form A
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Tractor(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)),
        );
        break;
      case 1:
      // Navigate to Form B
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => privatecar(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>CommercialC1(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>CommercialC(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>trailer(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Taxi(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)),
        );
        break;
      case 6:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Bus(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)),
        );
        break;
      case 7:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Firetruck(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)),
        );
        break;
      case 8:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>motorbikeA1(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)),
        );
        break;
      case 9:
        Navigator.push(context, MaterialPageRoute(builder: (context)=>motorbikeA(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)),
        );
        break;
    // Add more cases for additional options
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 35,),
          onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => driving(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)));
          },
        ),

        title: Text('Get New Licence', style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent,
        // Make the app bar transparent
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
            padding: const EdgeInsets.only(top:30.0),
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
            child: Padding(
              padding: const EdgeInsets.only(left:30.0,top:10),
              child: Column(
                children: <Widget>[
                  Text('Choose the license degree you want:',style: TextStyle(
                    color: primary,
                    fontFamily: 'SansSerif',
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),),
                  ListTile(
                    title: Text('01 truck license'),
                    leading: Radio(
                      value: 0,
                      groupValue: _selectedOption,
                      onChanged: (value){
                        _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('B private car'),
                    leading: Radio(
                      value: 1,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('C1 Commercial driving license till 15 Tons'),
                    leading: Radio(
                      value: 2,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('C Van driving license (Above 15 Tons)'),

                    leading: Radio(
                      value: 3,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('E trailer license'),
                    leading: Radio(
                      value: 4,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('D1 Taxi driving license'),
                    leading: Radio(
                      value: 5,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('D Bus driving license'),
                    leading: Radio(
                      value: 6,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Fire Truck driving license'),
                    leading: Radio(
                      value: 7,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('A1 Motor Bike Driving license till 500cm3'),
                    leading: Radio(
                      value: 8,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('A Motor Bike Driving licnese above 500cm3'),
                    leading: Radio(
                      value: 9,
                      groupValue: _selectedOption,
                      onChanged:(value){ _handleRadioValueChanged(value!);
                      },
                    ),
                  ),
                  // Add more ListTiles for additional options
                  Center(
                    child:  ElevatedButton(
                      onPressed: () {
                        _navigateToForm(context);
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
                            'Navigate',
                            style: TextStyle(color: primary,fontSize: 30),
                          ),
                          SizedBox(width: 15),
                          Icon(Icons.chevron_right, color: Secondary,size: 40,),
                        ],
                      ),
                    ),)
                ],
              ),
            ),
                    ),
          ),
        ]
      ),
    );
  }
}

// Define FormA widget
class Tractor extends StatefulWidget {
  Tractor({required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  State<Tractor> createState() => _TractorState();
}

class _TractorState extends State<Tractor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 35,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Newlicense(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)));
          },
        ),
        title: Text('Tractor License / Grade (01) Tractor Driving License:', style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent,
        // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 155, 210, 1),
                Color.fromRGBO(100, 19, 189, 1),
              ], // Define your gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
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
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 155, 210, 1),
                  Color.fromRGBO(100, 19, 189, 1),
                ],
              ),
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(top:30.0),
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
              child: Padding(
                padding: const EdgeInsets.only(top:8.0,left:30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1- The age should not be less than 16 years.',style: TextStyle(fontSize: 15),),
                    Text('2- Fill out the application form.',style: TextStyle(fontSize: 15),),
                    Text('3- Undergo a medical examination.',style:TextStyle(fontSize: 15)),
                    Text('4- Completion of a course from a tractor school accredited by the Ministry of Transportation.',style: TextStyle(fontSize: 15),),
                    Text('5- Undergo a practical driving test.',style:TextStyle(fontSize: 15)),
                    Text('6- Payment of the required fees.',style:TextStyle(fontSize: 15)),

                    Center(
                      child:  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context as BuildContext,
                          MaterialPageRoute(builder: (context)=>licenseform(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname,i:1)),
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
                            'Get Started',
                            style: TextStyle(color: primary,fontSize: 30),
                          ),
                          SizedBox(width: 15),
                          Icon(Icons.chevron_right, color: Secondary,size: 40,),
                        ],
                      ),
                    ),)
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
// Define FormB widget
class privatecar extends StatefulWidget {
  privatecar({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  State<privatecar> createState() => _privatecarState();
}

class _privatecarState extends State<privatecar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 35,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Newlicense(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)));
          },
        ),
        title: Text('Private Driving License / Grade (02) Private:', style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent,
        // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 155, 210, 1),
                Color.fromRGBO(100, 19, 189, 1),
              ], // Define your gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
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
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 155, 210, 1),
                  Color.fromRGBO(100, 19, 189, 1),
                ],
              ),
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(top:30.0),
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
              child: Padding(
                padding: const EdgeInsets.only(top:8.0,left:30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1- The age should not be less than 17 years for learning, and undergo tests and reserve the license until reaching 17.5 years after approval by the department director according to the system.',style: TextStyle(fontSize: 15),),
                    Text('2- Fill out the application form.',style: TextStyle(fontSize: 15),),
                    Text('3- Undergo a medical examination.',style:TextStyle(fontSize: 15)),
                    Text('4- Attend the traffic signs exam.',style: TextStyle(fontSize: 15),),
                    Text('5- Attend the practical driving exam.',style:TextStyle(fontSize: 15)),
                    Text('6- Payment of the required fees.',style:TextStyle(fontSize: 15)),

                    Center(
                      child:  ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context as BuildContext,
                            MaterialPageRoute(builder: (context)=>licenseform(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname,i:2)),
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
                              'Get Started',
                              style: TextStyle(color: primary,fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary,size: 40,),
                          ],
                        ),
                      ),)
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
// Define FormB widget
class CommercialC1 extends StatefulWidget {
  CommercialC1({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  State<CommercialC1> createState() => _CommercialC1State();
}

class _CommercialC1State extends State<CommercialC1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 35,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Newlicense(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)));
          },
        ),
        title: Text('Commercial Driving License / Grade (03) Commercial up to 15 tons:', style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent,
        // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 155, 210, 1),
                Color.fromRGBO(100, 19, 189, 1),
              ], // Define your gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
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
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 155, 210, 1),
                  Color.fromRGBO(100, 19, 189, 1),
                ],
              ),
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(top:30.0),
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
              child: Padding(
                padding: const EdgeInsets.only(top:8.0,left:30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("1- The applicant's age should not be less than (18) years.",style: TextStyle(fontSize: 15),),
                    Text('2- Medical examination from the medical institution to prevent road accidents for the required grade.',style: TextStyle(fontSize: 15),),
                    Text('3- Fill out the traffic signs form.',style:TextStyle(fontSize: 15)),
                    Text('4- Attend the traffic signs exam.',style: TextStyle(fontSize: 15),),
                    Text('5- Attend the practical driving test.',style:TextStyle(fontSize: 15)),
                    Text('6- Payment of the required fees.',style:TextStyle(fontSize: 15)),

                    Center(
                      child:  ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context as BuildContext,
                            MaterialPageRoute(builder: (context)=>licenseform(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname,i:3)),
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
                              'Get Started',
                              style: TextStyle(color: primary,fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary,size: 40,),
                          ],
                        ),
                      ),)
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
// Define FormB widget
class CommercialC extends StatefulWidget {
  CommercialC({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  State<CommercialC> createState() => _CommercialCState();
}

class _CommercialCState extends State<CommercialC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 35,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Newlicense(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)));
          },
        ),
        title: Text('Heavy Vehicle Driving License (Grade 13) - Cargo over 15 tons / Heavy Vehicle Ownership License:', style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent,
        // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 155, 210, 1),
                Color.fromRGBO(100, 19, 189, 1),
              ], // Define your gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
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
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 155, 210, 1),
                  Color.fromRGBO(100, 19, 189, 1),
                ],
              ),
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(top:30.0),
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
              child: Padding(
                padding: const EdgeInsets.only(top:8.0,left:30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1- The applicant age should not be less than 19 years.',style: TextStyle(fontSize: 15),),
                    Text('2- One year experience on a cargo license up to 15 tons (03).',style: TextStyle(fontSize: 15),),
                    Text('3- Certificate of heavy cargo course from an accredited institute licensed by the Ministry of Transportation.',style:TextStyle(fontSize: 15)),
                    Text('4- Medical examination from the medical institution to prevent road accidents for the required grade.',style: TextStyle(fontSize: 15),),
                    Text('5- Theoretical signals exam.',style:TextStyle(fontSize: 15)),
                    Text('6- Attend the practical driving test.',style:TextStyle(fontSize: 15)),
                    Text('7- Payment of the required fees.',style:TextStyle(fontSize: 15)),

                    Center(
                      child:  ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context as BuildContext,
                            MaterialPageRoute(builder: (context)=>licenseform(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname,i:4)),
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
                              'Get Started',
                              style: TextStyle(color: primary,fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary,size: 40,),
                          ],
                        ),
                      ),)
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
// Define FormB widget
class trailer extends StatefulWidget {
  trailer({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  State<trailer> createState() => _trailerState();
}

class _trailerState extends State<trailer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 35,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Newlicense(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)));
          },
        ),
        title: Text('Tractor and Trailer Driving License (Grade 4) / Trailer License:', style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent,
        // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 155, 210, 1),
                Color.fromRGBO(100, 19, 189, 1),
              ], // Define your gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 155, 210, 1),
                  Color.fromRGBO(100, 19, 189, 1),
                ],
              ),
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(top:30.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(top:8.0,left:30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1- The applicant age should not be less than 20 years.',style: TextStyle(fontSize: 15),),
                    Text('2- One year experience on a heavy cargo license 13 when submitting the application.',style: TextStyle(fontSize: 15),),
                    Text('3- Certificate of heavy cargo course from an institute licensed by the Ministry of Transportation.',style:TextStyle(fontSize: 15)),
                    Text('4- Medical examination from the medical institution to prevent road accidents for the required grade.',style: TextStyle(fontSize: 15),),
                    Text('5- School certificate up to fifth grade according to the executive regulations.',style:TextStyle(fontSize: 15)),
                    Text('6- Attend the practical driving test.',style:TextStyle(fontSize: 15)),
                    Text('7- Payment of the required fees.',style:TextStyle(fontSize: 15)),

                    Center(
                      child:  ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context as BuildContext,
                            MaterialPageRoute(builder: (context)=>licenseform(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname,i:5)),
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
                              'Get Started',
                              style: TextStyle(color: primary,fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary,size: 40,),
                          ],
                        ),
                      ),)
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
// Define FormB widget
class Taxi extends StatefulWidget {
  Taxi({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  State<Taxi> createState() => _TaxiState();
}

class _TaxiState extends State<Taxi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 35,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Newlicense(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)));
          },
        ),
        title: Text('Public License / Grade (5) Public Taxi Driving License:', style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent,
        // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 155, 210, 1),
                Color.fromRGBO(100, 19, 189, 1),
              ], // Define your gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
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
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 155, 210, 1),
                  Color.fromRGBO(100, 19, 189, 1),
                ],
              ),
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(top:30.0),
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
              child: Padding(
                padding: const EdgeInsets.only(top:8.0,left:30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1- The applicant age should not be less than 21 years.',style: TextStyle(fontSize: 15),),
                    Text('2- Two years of experience on grade 02, 03 private or commercial license.',style: TextStyle(fontSize: 15),),
                    Text('3- Certificate of public taxi course from an accredited institute licensed by the Ministry of Transportation.',style:TextStyle(fontSize: 15)),
                    Text('4- Medical examination from the medical institution to prevent road accidents for the required grade.',style: TextStyle(fontSize: 15),),
                    Text('5- School certificate up to the second preparatory grade certified as successful according to the executive regulations.',style:TextStyle(fontSize: 15)),
                    Text('6- Good conduct certificate from the Ministry of Interior.',style:TextStyle(fontSize: 15)),
                    Text('7- Theoretical examination.',style:TextStyle(fontSize: 15)),
                    Text('8- Attend the practical driving test.',style:TextStyle(fontSize: 15)),
                    Text('9- Payment of the required fees.',style:TextStyle(fontSize: 15)),

                    Center(
                      child:  ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context as BuildContext,
                            MaterialPageRoute(builder: (context)=>licenseform(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname,i:6)),
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
                              'Get Started',
                              style: TextStyle(color: primary,fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary,size: 40,),
                          ],
                        ),
                      ),)
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
// Define FormB widget
class Bus extends StatefulWidget {
  Bus({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  State<Bus> createState() => _BusState();
}

class _BusState extends State<Bus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 35,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Newlicense(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)));
          },
        ),
        title: Text('Public Bus License / Grade (6) Public Bus:', style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent,
        // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 155, 210, 1),
                Color.fromRGBO(100, 19, 189, 1),
              ], // Define your gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
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
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 155, 210, 1),
                  Color.fromRGBO(100, 19, 189, 1),
                ],
              ),
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(top:30.0),
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
              child: Padding(
                padding: const EdgeInsets.only(top:8.0,left:30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1- The applicant age should not be less than 21 years.',style: TextStyle(fontSize: 15),),
                    Text('2- Two years of experience on grade (03) commercial license.',style: TextStyle(fontSize: 15),),
                    Text('3- Certificate of public bus course from an accredited institute licensed by the Ministry of Transportation.',style:TextStyle(fontSize: 15)),
                    Text('4- Medical examination from the medical institution to prevent road accidents for the required grade.',style: TextStyle(fontSize: 15),),
                    Text('5- School certificate up to the second preparatory grade certified as successful according to the executive regulations.',style:TextStyle(fontSize: 15)),
                    Text('6- Good conduct certificate from the Ministry of Interior.',style:TextStyle(fontSize: 15)),
                    Text('7- Theoretical examination.',style:TextStyle(fontSize: 15)),
                    Text('8- Attend the practical driving test.',style:TextStyle(fontSize: 15)),
                    Text('9- Payment of the required fees.',style:TextStyle(fontSize: 15)),

                    Center(
                      child:  ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context as BuildContext,
                            MaterialPageRoute(builder: (context)=>licenseform(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname,i:7)),
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
                              'Get Started',
                              style: TextStyle(color: primary,fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary,size: 40,),
                          ],
                        ),
                      ),)
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
// Define FormB widget
class Firetruck extends StatefulWidget {
  Firetruck({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  State<Firetruck> createState() => _FiretruckState();
}

class _FiretruckState extends State<Firetruck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 35,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Newlicense(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)));
          },
        ),
        title: Text('Fire Vehicle Driving License/ Grade (03) license and above for two years or more:', style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent,
        // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 155, 210, 1),
                Color.fromRGBO(100, 19, 189, 1),
              ], // Define your gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
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
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 155, 210, 1),
                  Color.fromRGBO(100, 19, 189, 1),
                ],
              ),
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(top:30.0),
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
              child: Padding(
                padding: const EdgeInsets.only(top:8.0,left:30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1- Civil Defense course certificate from the Civil Defense according to the ministry agreement.',style: TextStyle(fontSize: 15),),
                    Text('2- Medical examination from the medical institution to prevent road accidents for the required grade.',style: TextStyle(fontSize: 15),),
                    Text('3- At least 10 years of education.',style:TextStyle(fontSize: 15)),
                    Text('4- Good conduct certificate from the Ministry of Interior.',style: TextStyle(fontSize: 15),),
                    Text('5- Theoretical and practical exams from the Civil Defense.',style:TextStyle(fontSize: 15)),
                    Text('6- Certificate approval from the licensing authority.',style:TextStyle(fontSize: 15)),


                    Center(
                      child:  ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context as BuildContext,
                            MaterialPageRoute(builder: (context)=>licenseform(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname,i:8)),
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
                              'Get Started',
                              style: TextStyle(color: primary,fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary,size: 40,),
                          ],
                        ),
                      ),)
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
// Define FormB widget
class motorbikeA1 extends StatefulWidget {
  motorbikeA1({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  State<motorbikeA1> createState() => _motorbikeA1State();
}

class _motorbikeA1State extends State<motorbikeA1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 35,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Newlicense(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)));
          },
        ),
        title: Text('Motorcycle Driving License (B) up to 500 cc:', style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent,
        // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 155, 210, 1),
                Color.fromRGBO(100, 19, 189, 1),
              ], // Define your gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
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
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 155, 210, 1),
                  Color.fromRGBO(100, 19, 189, 1),
                ],
              ),
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(top:30.0),
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
              child: Padding(
                padding: const EdgeInsets.only(top:8.0,left:30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1- The applicant age should not be less than 17 years.',style: TextStyle(fontSize: 15),),
                    Text("2- Guardian's approval.",style: TextStyle(fontSize: 15),),
                    Text('3- Vision test from the medical institution for the required grade.',style:TextStyle(fontSize: 15)),
                    Text('4- Pass the theoretical exam, and if holding a grade 2 license or above, exempt from the theoretical exam.',style: TextStyle(fontSize: 15),),
                    Text('5- Pass the practical driving test.',style:TextStyle(fontSize: 15)),

                    Center(
                      child:  ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context as BuildContext,
                            MaterialPageRoute(builder: (context)=>licenseform(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname,i:9)),
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
                              'Get Started',
                              style: TextStyle(color: primary,fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary,size: 40,),
                          ],
                        ),
                      ),)
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
class motorbikeA extends StatefulWidget {
  motorbikeA({ required this.userId, required this.firstname, required this.lastname});
  final String userId;
  final String firstname;
  final String lastname;
  @override
  State<motorbikeA> createState() => _motorbikeAState();
}

class _motorbikeAState extends State<motorbikeA> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 35,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Newlicense(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname)));
          },
        ),
        title: Text('Motorcycle Driving License (C) over 500 cc:', style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerif'
        ),),
        backgroundColor: Colors.transparent,
        // Make the app bar transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 155, 210, 1),
                Color.fromRGBO(100, 19, 189, 1),
              ], // Define your gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
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
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 155, 210, 1),
                  Color.fromRGBO(100, 19, 189, 1),
                ],
              ),
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(top:30.0),
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
              child: Padding(
                padding: const EdgeInsets.only(top:8.0,left:30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1- The applicant age should not be less than 21 years.',style: TextStyle(fontSize: 15),),
                    Text('2- One year experience on a (B) license.',style: TextStyle(fontSize: 15),),
                    Text('3- Vision test from the medical institution for the required grade.',style:TextStyle(fontSize: 15)),
                    Text('4- Pass the theoretical exam, and if holding a grade 2 license or above, exempt from the theoretical exam.',style: TextStyle(fontSize: 15),),
                    Text('5- Pass the practical driving test.',style:TextStyle(fontSize: 15)),
                    Text('6- Good conduct certificate from the Ministry of Interior.',style:TextStyle(fontSize: 15)),
                    Text('7- Theoretical examination.',style:TextStyle(fontSize: 15)),
                    Text('8- Attend the practical driving test.',style:TextStyle(fontSize: 15)),
                    Text('9- Payment of the required fees.',style:TextStyle(fontSize: 15)),

                    Center(
                      child:  ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context ,
                            MaterialPageRoute(builder: (context)=>licenseform(userId:widget.userId,firstname:widget.firstname,lastname:widget.lastname,i:10)),
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
                              'Get Started',
                              style: TextStyle(color: primary,fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.chevron_right, color: Secondary,size: 40,),
                          ],
                        ),
                      ),)
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

