import 'dart:io';

import 'package:clientmanager/screens/home/client/client_screen.dart';
import 'package:clientmanager/screens/home/client/edit_client.dart';
import 'package:clientmanager/screens/home/seller/add_seller.dart';
import 'package:clientmanager/screens/home/seller/show_seller.dart';
import 'package:clientmanager/screens/home/seller/edit_seller.dart';
import 'package:clientmanager/screens/home/seller/seller_client.dart';
import 'package:clientmanager/services/auth.dart';
import 'package:clientmanager/services/seller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({Key? key}) : super(key: key);

  @override
  _SellerScreenState createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Sellers",
          style: TextStyle(
            color: Colors.grey[700],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: exportExcel,
            child: SvgPicture.asset('assets/icons/excel.svg'),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () async {
              String msg = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddSeller()),
              );

              Fluttertoast.showToast(
                msg: msg,
                fontSize: 16,
                backgroundColor: Colors.green,
              );
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
          stream: db.collection('sellers').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              dynamic data = snapshot.data;
              if (data.docs.length >= 1) {
                return ListView.builder(
                  itemCount: data.docs.length,
                  itemBuilder: (context, index) {
                    return Slidable(
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
                              final res = SellerService()
                                  .deleteSeller(data.docs[index].id);
                              if (res != null) {
                                Fluttertoast.showToast(
                                    msg: 'Le patron a été supprimé',
                                    backgroundColor: Colors.red);
                              }
                            },
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            // label: 'Supprimer',
                          ),

                          SlidableAction(
                            onPressed: (BuildContext ctx) async {
                              String id = await data.docs[index].id;
                              // print(id);
                              String res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditSeller(
                                      id: id,
                                    ),
                                  ));

                              Fluttertoast.showToast(
                                msg: res,
                                backgroundColor: Colors.green,
                              );
                            },
                            backgroundColor: Color.fromARGB(255, 39, 163, 225),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            // label: 'Éditer',
                          ),

                          SlidableAction(
                            onPressed: (BuildContext context) async {
                              String id = data.docs[index].id;

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          ShowSeller(id: id))));
                            },
                            backgroundColor: Color.fromARGB(255, 40, 51, 56),
                            foregroundColor: Colors.white,
                            icon: Icons.visibility,
                            // label: 'Aficher',
                          ),

                          SlidableAction(
                            onPressed: (BuildContext context) async {
                              String id = data.docs[index].id;
                              String name = data.docs[index]['name'];

                              final res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => SellerClients(
                                            id: id,
                                            name: name,
                                          ))));
                            },
                            backgroundColor: Color.fromARGB(255, 66, 72, 221),
                            foregroundColor: Colors.white,
                            icon: Icons.people,
                            // label: 'Aficher',
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: ListTile(
                          leading: SvgPicture.asset(
                            'assets/icons/boss.svg',
                            width: 40,
                          ),
                          title: Text("${data.docs[index]['name']}"),
                          subtitle: Text("${data.docs[index]['sector']}"),
                          tileColor: Colors.white,
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('Pas encore de vendeurs'),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
          }),
    );
  }

  // ListView clientList() {
  //   return ListView.builder(
  //     itemCount: clients.length,
  //     itemBuilder: (BuildContext ctx, int index) => Container(
  //       padding: const EdgeInsets.all(17.0),
  //       margin: const EdgeInsets.only(bottom: 2),
  //       decoration: const BoxDecoration(
  //         color: Colors.white,
  //         // borderRadius: BorderRadius.all(Radius.circular(10)),
  //       ),
  //       child: ItemListView(index),
  //     ),
  //   );
  // }
  /*
  Row ItemListView(int index, DocumentSnapshot doc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doc["name"].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 7),
            Text(
              doc["sector"].toString(),
              style: TextStyle(color: Colors.grey[500]),
            )
          ],
        ),
        Row(
          children: [
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SellerClients()),
                    );
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/clients.svg',
                    // width: 40,
                    // height: 40,
                    color: Colors.cyan[700],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    String msg = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditSeller(
                                id: doc.id,
                              )),
                    );

                    if (msg != null) {
                      final snackBar = SnackBar(
                        backgroundColor: Colors.green[400],
                        content: Text(msg),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan[700],
                  ),
                )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowSeller(id: doc.id),
                        ));
                  },
                  icon: Icon(
                    Icons.visibility,
                    color: Colors.cyan[700],
                  ),
                ),
                IconButton(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Warning!'),
                      content: const Text('Are you sure?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => deleteUser(doc),
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  ),
                  icon: Icon(
                    Icons.delete,
                    color: Colors.cyan[700],
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
*/
}

void exportExcel() async {
  List<List<String>> data = [];
  data.add(['name', 'phone', 'email', 'city', 'sector']);
  dynamic dbDta = FirebaseFirestore.instance
      .collection('sellers')
      .get()
      .then((value) async {
    for (var item in value.docs) {
      data.add([
        item.get('name'),
        item.get('phone'),
        item.get('email'),
        item.get('city'),
        item.get('sector')
      ]);
    }

    var status = await Permission.storage.request();

    if (status.isGranted) {
      String csvData = ListToCsvConverter().convert(data);
      Directory downloads = Directory('/storage/emulated/0/Download');
      final file = await (File('${downloads.path}/sellers.csv').create());

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
