import 'package:flutter/material.dart';
import 'package:graduationprojectweb/widgets/BuildButton.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
class applications extends StatefulWidget {
  applications({ required this.userId, required this.firstname, required this.lastname, required this.isEnglish});
  final String userId;
  final String firstname;
  final String lastname;
  final bool isEnglish;

  @override
  State<applications> createState() => _applicationsState();
}

class _applicationsState extends State<applications> {
  bool isEnglish =true;

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEnglish=widget.isEnglish;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(context, isEnglish? 'Applications':'الطلبات', widget.userId, widget.firstname, widget.lastname,isEnglish,_toggleLanguage),

      body: Stack(

        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
             color: Colors.white
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 80, 25, 50),
              child: ListView(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          buildButton.buildbutton(context, 'all', isEnglish?"All Applications":'كل الطلبات', 'assets/application.png',widget.userId,widget.firstname,widget.lastname,isEnglish),
                          buildButton.buildbutton(context, 'rejected', isEnglish?"Rejected Applications":'الطلبات المرفوضة', 'assets/rejected.png',widget.userId,widget.firstname,widget.lastname,isEnglish),
                          buildButton.buildbutton(context, 'finished', isEnglish?"Finished Applications":'الطلبات المقبولة', 'assets/list.png',widget.userId,widget.firstname,widget.lastname,isEnglish),
                          buildButton.buildbutton(context, 'notdone', isEnglish?"In-progress Applications":'الطلبات التي لم تتم مراجعتها', 'assets/progress.png',widget.userId,widget.firstname,widget.lastname,isEnglish),

                        ],
                      )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
