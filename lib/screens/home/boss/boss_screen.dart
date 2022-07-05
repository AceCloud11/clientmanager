import 'package:clientmanager/screens/home/boss/add_boss.dart';
import 'package:clientmanager/screens/home/boss/edit_boss.dart';
import 'package:clientmanager/services/boss.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BossScreen extends StatelessWidget {
  const BossScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              String msg = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddBoss()),
              );

              Fluttertoast.showToast(
                msg: msg,
                fontSize: 16,
                backgroundColor: Colors.green,
              );
            },
            icon: const Icon(
              Icons.person_add,
              size: 28,
            ),
            color: Colors.blue,
          ),
          const SizedBox(
            width: 10,
          ),
        ],
        elevation: 0,
      ),
      body: StreamBuilder<Object>(
          stream: FirebaseFirestore.instance.collection('bosses').snapshots(),
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
                        dismissible: DismissiblePane(onDismissed: () {}),

                        // All actions are defined in the children parameter.
                        children: [
                          // A SlidableAction can have an icon and/or a label.
                          SlidableAction(
                            onPressed: (BuildContext context) {
                              final res =
                                  BossService().deleteBoss(data.docs[index].id);
                              if (res != null) {
                                Fluttertoast.showToast(
                                    msg: 'Le patron a été supprimé',
                                    backgroundColor: Colors.red);
                              }
                            },
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Supprimer',
                          ),

                          SlidableAction(
                            onPressed: (BuildContext context) async {
                              String id = data.docs[index].id;

                              final res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          EditBoss(id: id))));
                            },
                            backgroundColor: Color.fromARGB(255, 39, 163, 225),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Éditer',
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
                          subtitle: Text("${data.docs[index]['phone']}"),
                          tileColor: Colors.white,
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No Bosses yet'),
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
}
