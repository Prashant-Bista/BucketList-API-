import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Addbucketlist extends StatefulWidget {
  int newIndex;
  Addbucketlist({super.key,required this.newIndex});

  @override
  State<Addbucketlist> createState() => _AddbucketlistState();
}

class _AddbucketlistState extends State<Addbucketlist> {
  TextEditingController itemController= TextEditingController();
  TextEditingController costController= TextEditingController();
  TextEditingController imageController= TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> addData() async{
    try{
      Map<String,dynamic> data ={
        "item":itemController.text,
        "cost":costController.text,
        "image":imageController.text,
        "completed":false,
      };
      Response response = await Dio().patch("https://apitest-3f485-default-rtdb.firebaseio.com/bucketlist/${widget.newIndex}.json",data:data);
      Navigator.pop(context,"refresh");
    }catch(e){
      print("error");

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add bucket List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: itemController,
                validator: (value){
                  if(value==null ||value.isEmpty)
                    return "Item is required";
                  else
                    return null;
                },
                decoration: InputDecoration(
                  label:Text("Item")
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value){
                  if(value==null ||value.isEmpty)
                    return "Cost is required";
                  else
                    return null;
                },
                controller: costController,
                decoration: InputDecoration(
                    label:Text("Estimated Cost")
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                  validator: (value){
                  if(value==null ||value.isEmpty)
                    return "Image URl is required";

                  else
                    return null;
                },
                controller: imageController,
                decoration: InputDecoration(
                    label:Text("Image URL")
                ),
              ),
              SizedBox(height: 20,),
             ElevatedButton(onPressed: (){
               if(formKey.currentState!.validate())
                 addData();
               // addData();
             }, child: Text("Add data")),
            ],
          ),
        ),
      ),
    ) ;
  }
}
