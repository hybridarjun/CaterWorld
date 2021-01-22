//Package Import
import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MealsScreen extends StatefulWidget {
  static const routeName = '/views-screen';

  final Function toggleFavorite;

  final String title;
  final String cuisine;
  final String dishStory;
  final String dishId;
  bool isFavorite;

  MealsScreen(
      {Key key,
      this.title,
      this.cuisine,
      this.dishStory,
      this.dishId,
      this.toggleFavorite,
      this.isFavorite})
      : super(key: key);

  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final image1 = 'assets/images/Patriotic-Charcuterie-Board-RC.png';

  final String nonVeg = 'assets/icons/Non-Veg.svg';

  final String favIcon = 'assets/icons/Heartv2.svg';

  final String likedbuttom = 'assets/icons/liked.svg';

  // bool isFavorite = false;

  void _likedThis() async {
    final user = await FirebaseAuth.instance.currentUser();
    final userData = Firestore.instance.collection('users').document(user.uid);
    if (widget.isFavorite == false) {
      userData.updateData({
        "data": FieldValue.arrayUnion([widget.dishId])
      });

      setState(() {
        widget.isFavorite = true;
      });
    } else {
      userData.updateData({
        "data": FieldValue.arrayRemove([widget.dishId])
      });

      setState(() {
        widget.isFavorite = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(widget.isFavorite),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 24,
            fontFamily: '.SF Pro Display',
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(120, 115, 115, 1),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 350,
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: 10,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                child: PageView(
                  controller: PageController(viewportFraction: 1),
                  children: [
                    Image.asset(
                      image1,
                      //height: 80,
                      //width: 80,
                    ),
                    Image.asset(
                      image1,
                      //height: 80,
                      //width: 80,
                    ),
                    Image.asset(
                      image1,
                      //height: 80,
                      //width: 80,
                    ),
                    Image.asset(
                      image1,
                      //height: 80,
                      //width: 80,
                    ),
                  ],
                ),
                // child: GridView.count(
                //   physics: NeverScrollableScrollPhysics(),
                //   crossAxisCount: 2,
                //   children: [
                //     Image.asset(
                //       image1,
                //       height: 80,
                //       width: 80,
                //     ),
                //     Image.asset(
                //       image1,
                //       height: 80,
                //       width: 80,
                //       //fit: BoxFit.cover,
                //     ),
                //     Image.asset(
                //       image1,
                //       height: 80,
                //       width: 80,
                //       //fit: BoxFit.cover,
                //     ),
                //     Image.asset(
                //       image1,
                //       height: 80,
                //       width: 80,
                //       //fit: BoxFit.cover,
                //     )
                //   ],
                // ),
              ),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(50),
              // ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: '.SF Pro Display',
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(120, 115, 115, 1),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                      ),
                      Text(
                        widget.cuisine,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: '.SF Pro Display',
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(120, 115, 115, 1),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 30),
                      ),
                      SvgPicture.asset(
                        nonVeg,
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                      ),
                      IconButton(
                        icon: !widget.isFavorite
                            ? SvgPicture.asset(
                                favIcon,
                                height: 35,
                              )
                            : SvgPicture.asset(
                                likedbuttom,
                                height: 35,
                              ),
                        onPressed: _likedThis,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 10,
                top: 10,
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Story Behind This Dish",
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: '.SF Pro Display',
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(120, 115, 115, 1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                  ),
                  Text(
                    widget.dishStory,
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: '.SF Pro Display',
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(120, 115, 115, 1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              const Color(0xFFF7F0DD),
            ],
          ),
          //boxShadow: [BoxShadow(spreadRadius: 2,),],
        ),
      ),
    );
  }
}
