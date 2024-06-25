import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


class List {
  static Container buildList(BuildContext context, String text, String img) {
    return  Container( padding: const EdgeInsets.only(right: 5,left: 5),
      margin: const EdgeInsets.only(right: 12),
      height: 500,
      width: 400,
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(25), // Adjust the radius as per your requirement
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(image: AssetImage(img),height: 300,color: Colors.white,),
          Text(text, style: TextStyle(
            fontSize: 25,
            color: Colors.white,

          ),textAlign: TextAlign.justify,)
        ],
      ),);
  }
}
