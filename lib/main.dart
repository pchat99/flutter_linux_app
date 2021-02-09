import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var com;
  var data;
  var out;
  @override
  Widget build(BuildContext context) {
    var fsconnect = FirebaseFirestore.instance;

    myfbget() async {
      var c = await fsconnect.collection("pranav").get();
      for (var i in c.docs) {
        print(i.data());
      }
    }

    myapiget(q) async {
      var url = "http://192.168.1.2/cgi-bin/web.py?x=$q";
      var r = await http.get(url);
      // var data = r.body;
      setState(() {
        data = r.body;
      });
    }

    //var wid = MediaQuery.of(this.context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: Text(
              "LinuxMobile",
              style: TextStyle(color: Colors.black),
            ),
            leading: Icon(Icons.menu, color: Colors.black),
            backgroundColor: Colors.orangeAccent),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(1),
                  spreadRadius: 30,
                  blurRadius: 20,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                TextField(
                  onChanged: (x) {
                    com = x;
                  },
                  autocorrect: false,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Write your Linux Command",
                      prefixIcon: Icon(Icons.arrow_forward)),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                    child: Text("Submit"),
                    color: Colors.orangeAccent,
                    onPressed: () async {
                      await myapiget(com);
                      fsconnect.collection("pranav").add({
                        '$com': '$data',
                      });
                      print('Submitting');
                    }),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                    child: Text("Get"),
                    color: Colors.orangeAccent,
                    onPressed: () {
                      print("Getting");
                      try {
                        out = myfbget();
                        print(data);
                      } catch (e) {
                        print("Error");
                      }
                    }),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    data ?? "Fetching data..",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  color: Colors.orangeAccent,
                  padding: EdgeInsets.all(4),
                  alignment: Alignment.center,
                  width: 250,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
