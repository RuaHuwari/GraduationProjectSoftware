import 'package:flutter/material.dart';

class FooterPage extends StatefulWidget {
  final bool isEnglish;

  FooterPage({required this.isEnglish});

  @override
  State<FooterPage> createState() => _FooterPageState();
}

class _FooterPageState extends State<FooterPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Section
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PalEase',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 27,
                    fontFamily: 'SandSerif',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.isEnglish
                      ? 'PalEase is a comprehensive platform designed to simplify your life by providing a wide range of services at your fingertips. From obtaining your ID to accessing healthcare, PalEase is here to assist you.'
                      : 'بالإمكان هو منصة شاملة مصممة لتبسيط حياتك من خلال تقديم مجموعة واسعة من الخدمات في متناول يدك. من الحصول على هويتك إلى الوصول إلى الرعاية الصحية، بالإمكان هنا لمساعدتك.',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 100,),
          // Middle Section
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEnglish ? 'Our Services' : 'خدماتنا',
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.isEnglish
                          ? '• ID Services\n• Passport Services\n• Driving License\n• Education\n'
                          : '• خدمات الهوية\n• خدمات جواز السفر\n• رخصة القيادة\n• التعليم\n',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      widget.isEnglish
                          ? '• Orphanages\n• Special Needs\n• Healthcare'
                          : '• دور الأيتام\n• احتياجات خاصة\n• الرعاية الصحية',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Right Section
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEnglish ? 'Contact Us' : 'اتصل بنا',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.isEnglish
                      ? 'Email: info@palease.com\nPhone: +970595204077\nAddress: Sebastia, Nablus, Palestine'
                      : 'البريد الإلكتروني: info@palease.com\nالهاتف: +123 456 7890\nالعنوان: 1234 اسم الشارع، المدينة، البلد',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
