import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
class ViewItem extends StatefulWidget {
  String image;
  String title;
  int index;
  ViewItem({super.key, required this.title, required this.image,required this.index});

  @override
  State<ViewItem> createState() => _ViewItemState();
}

class _ViewItemState extends State<ViewItem> {
  Future<void> deleteData() async{
    try{
      Response response = await Dio().delete("https://apitest-3f485-default-rtdb.firebaseio.com/bucketlist/${widget.index}.json");
      Navigator.pop(context,"refresh");
    }catch(e){
      print("error");

    }
  }
  Future<void> markAsComplete() async{
    try{
      Map<String,dynamic> data ={
        "completed":true
      };
      Response response = await Dio().patch("https://apitest-3f485-default-rtdb.firebaseio.com/bucketlist/${widget.index}.json",data:data);
      Navigator.pop(context,"refresh");
    }catch(e){
      print("error");

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text("Delete"),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Text("Mark as Done"),
                  value: 2,
                )
              ];
            },
            onSelected: (value) {
              if (value == 1) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Do you really want to delete?"),
                        actions: [
                          InkWell(
                            child: Text("Cancel"),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          InkWell(
                            child: Text("Delete"),
                            onTap: () {
                              deleteData();
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    });
              }
              if(value==2){
                markAsComplete();
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.image), fit: BoxFit.fill)),
          ),
        ],
      ),
    );
  }
}
