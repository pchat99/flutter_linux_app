import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  var fsconnect = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          'Command History',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: fsconnect.collection('terminal_outputs').snapshots(),
              builder: (context, snapshot) {
                var msg = snapshot.data.docs;
                List<Widget> y = [];
                for (var d in msg) {
                  var commandName = d.data()['commandName'].toString();
                  var commandOutput = d.data()['commandOutput'].toString();
                  print(commandName);
                  var comm = Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            commandName,
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            commandOutput,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ],
                  );
                  y.add(comm);
                }
                return Container(
                  child: Column(
                    children: y,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
© 2021 GitHub, Inc.
