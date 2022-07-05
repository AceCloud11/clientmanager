import 'dart:developer';
import 'dart:io';

import 'package:clientmanager/screens/home/client/client_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class SellerClients extends StatefulWidget {
  const SellerClients({Key? key, required this.id, required this.name})
      : super(key: key);

  final String id;
  final String name;

  @override
  _SellerClientsState createState() => _SellerClientsState();
}

class _SellerClientsState extends State<SellerClients> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        // elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_circle_left_rounded,
            color: Colors.grey[700],
            size: 32,
          ),
        ),
        title: Text(
          "${widget.name} Clients",
          style: TextStyle(
            color: Colors.grey[700],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: GestureDetector(
              onTap: () => exportExcel(widget.id, widget.name),
              child: SvgPicture.asset('assets/icons/excel.svg'),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<Object>(
                    stream: FirebaseFirestore.instance
                        .collection('clients')
                        .where('seller_id', isEqualTo: widget.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        dynamic data = snapshot.data;
                        return clientList(data.docs);
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        );
                      }
                    }))
          ],
        ),
      ),
    );
  }

  ListView clientList(data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext ctx, int index) => Container(
          padding: const EdgeInsets.all(17.0),
          margin: const EdgeInsets.only(bottom: 2),
          decoration: const BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text("name: "),
                  Text(
                    "${data[index]['name']}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("seller: "),
                  Text(
                    "${data[index]['seller']}",
                    style: TextStyle(color: Colors.cyan[400]),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("city: "),
                  Text(
                    "${data[index]['city']}",
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("type: "),
                  Text(
                    "${data[index]['type']}",
                  ),
                ],
              )
            ],
          )),
    );
  }
}

void exportExcel(String id, String name) async {
  List<List<String>> data = [];
  data.add(
      ['name', 'phone', 'seller', 'city', 'type', 'latitude', 'langitude']);
  dynamic dbDta = FirebaseFirestore.instance
      .collection('clients')
      .where('seller_id', isEqualTo: id)
      .get()
      .then((value) async {
    for (var item in value.docs) {
      data.add([
        item.get('name'),
        item.get('phone'),
        item.get('seller'),
        item.get('city'),
        item.get('type'),
        item.get('coordinates')['lat'].toString(),
        item.get('coordinates')['lng'].toString(),
      ]);
    }

    var status = await Permission.storage.request();

    if (status.isGranted) {
      String csvData = ListToCsvConverter().convert(data);
      Directory downloads = Directory('/storage/emulated/0/Download');
      final file =
          await (File('${downloads.path}/${name}_clients.csv').create());

      await file.writeAsString(csvData);
      Fluttertoast.showToast(
        msg: "File was exported successfully",
        fontSize: 16,
        backgroundColor: Colors.green,
      );
      // print(csvData);
    }
  });
}
