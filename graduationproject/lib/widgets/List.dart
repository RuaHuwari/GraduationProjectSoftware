import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


class List {
  static Container buildList(BuildContext context, String text, String img) {
    return  Container( padding: const EdgeInsets.only(right: 5,left: 5),
      margin: const EdgeInsets.only(right: 12),
      width: 300,
      decoration: BoxDecoration(
        color: Color.fromRGBO(100, 19, 189, 0.3),
        borderRadius: BorderRadius.circular(25), // Adjust the radius as per your requirement
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(image: AssetImage(img),height: 100,color: Colors.white,),
          Text(text, style: TextStyle(
            fontSize: 12,
            color: Colors.white,

          ),textAlign: TextAlign.justify,)
        ],
      ),);
  }
}
