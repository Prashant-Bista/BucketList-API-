import 'package:bucket_list/addBucketList.dart';
import 'package:bucket_list/viewItem.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> bucketList = [];
  bool isLoading = true;
  bool iserror = false;
  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get(
          "https://apitest-3f485-default-rtdb.firebaseio.com/bucketlist.json");
      if (response.data is List){
        bucketList = response.data;
      }
      else{
        bucketList=[];
      }
      isLoading = false;
      iserror = false;

      setState(() {});
    } catch (e) {
      isLoading = false;
      iserror = true;
      setState(() {});

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BucketList"),
        actions: [
          InkWell(
            child: Icon(Icons.refresh),
            onTap: () {
              getData();
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getData();
        },
        child: isLoading
            ? LinearProgressIndicator()
            : iserror
                ? errorWidget():listDataWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Addbucketlist(newIndex: bucketList.length,))).then((value){
                if(value=='refresh')
                getData();});
        },
        child: Icon(Icons.add),
      ),
    );
  }
  Widget errorWidget(){
   return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning),
            Text("Error getting the bucket list data"),
            ElevatedButton(onPressed: (){
              setState(() {
                getData();
              });
            }, child: Text("Try again"))

          ])
    );
  }
  Widget listDataWidget(){
    List<dynamic> filteredList =bucketList.where((element)=> !element?["completed"]??false).toList();
    return filteredList.length<1?Center(child: Text("No data in BucketList",style: TextStyle(fontSize: 20),)):ListView.builder(
        itemCount: bucketList.length,
        itemBuilder: (context, index) {
          return (bucketList[index] is Map && !bucketList[index]?["completed"] ?? false)? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewItem(index: index,
                            title: bucketList[index]['item'],
                            image: bucketList[index]['image']))).then((value){
                              if(value=="refresh")
                                getData();
                });
              },
              leading: CircleAvatar(
                radius: 100,
                backgroundImage:
                NetworkImage(bucketList[index]?['image']??""),
              ),
              title: Text(bucketList[index]?['item'] ?? ""),
              trailing: Text(
                "Cost: ${bucketList[index]['cost'].toString()}",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ):SizedBox();
        });
  }
}
