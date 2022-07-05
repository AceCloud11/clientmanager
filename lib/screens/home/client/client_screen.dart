import 'dart:io';

import 'package:clientmanager/screens/home/client/add_client.dart';
import 'package:clientmanager/screens/home/client/client_map.dart';
import 'package:clientmanager/screens/home/seller/seller_screen.dart';
import 'package:clientmanager/services/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Clients",
          style: TextStyle(
            color: Colors.grey[700],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => exportExcel(),
            child: SvgPicture.asset('assets/icons/excel.svg'),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () async {
              String msg = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddClient()),
              );

              if (msg != null) {
                Fluttertoast.showToast(msg: msg, backgroundColor: Colors.green);
              }
            },
            child: SvgPicture.asset(
              'assets/icons/add_user.svg',
              width: 70,
              height: 40,
              color: Colors.indigo[900],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: StreamBuilder<Object>(
          stream: db
              .collection('clients')
              .where('seller_id', isEqualTo: user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              dynamic data = snapshot.data;

              if (data.docs.length >= 1) {
                return clientList(data!.docs);
              } else {
                return const Center(
                  child: Text('No Clients yet'),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }
          }),
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
          child: Slidable(
            key: const ValueKey(0),

            // The start action pane is the one at the left or the top side.
            startActionPane: ActionPane(
              // A motion is a widget used to control how the pane animates.
              motion: const ScrollMotion(),

              // A pane can dismiss the Slidable.
              // dismissible: DismissiblePane(onDismissed: () {}),

              // All actions are defined in the children parameter.
              children: [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: (BuildContext context) {
                    final res = ClientService().deleteCleint(data[index].id);
                    if (res != null) {
                      Fluttertoast.showToast(
                          msg: 'Client is deleted',
                          backgroundColor: Colors.red);
                    }
                  },
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
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
                    const Text("location: "),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClientMap(coordinates: {
                                "lat": data[index]['coordinates']['lat'],
                                "lng": data[index]['coordinates']['lng']
                              }),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.place,
                          color: Colors.blue,
                        ))
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
            ),
          )),
    );
  }
}

void exportExcel() async {
  List<List<String>> data = [];
  data.add(
      ['name', 'phone', 'seller', 'city', 'type', 'latitude', 'langitude']);
  dynamic dbDta = FirebaseFirestore.instance
      .collection('clients')
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
      final file = await (File('${downloads.path}/clients.csv').create());

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

void deleteClient(BuildContext context, String id) {
  ClientService().deleteCleint(id);
}
