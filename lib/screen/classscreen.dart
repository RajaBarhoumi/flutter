import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tp70/service/classeservice.dart';
import 'package:tp70/template/dialog/classedialog.dart';
import 'package:tp70/template/navbar.dart';

import '../entities/classe.dart';

class ClasseScreen extends StatefulWidget {
  @override
  _ClasseScreenState createState() => _ClasseScreenState();
}

class _ClasseScreenState extends State<ClasseScreen> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar('classes'),
      body: FutureBuilder(
        future: getAllClasses(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Slidable(
                  key: Key((snapshot.data[index]['codClass']).toString()),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ClassDialog(
                                notifyParent: refresh,
                                onClassSelected: (selectedClass, selectedMatiere) {
                                  // Implement your logic to add matiere to the selected class
                                  if (selectedClass != null) {
                                    addMatiereToClasse(selectedClass.codClass!, 0);
                                    refresh();
                                  }
                                },
                                classe: null,
                              );
                            },
                          );
                        },
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    dismissible: DismissiblePane(onDismissed: () async {
                      await deleteClass(snapshot.data[index]['codClass']);
                      setState(() {
                        snapshot.data.removeAt(index);
                      });
                    }),
                    children: [Container()],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("Classe : "),
                                Text(
                                  snapshot.data[index]['nomClass'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 2.0,
                                ),
                              ],
                            ),
                            Text(
                              "Nombre etudiants : ${snapshot.data[index]['nbreEtud']}",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ClassDialog(
                notifyParent: refresh,
                onClassSelected: (selectedClass, selectedMatiere) {
                  // Implement your logic to add matiere to the selected class
                  if (selectedClass != null) {
                    addMatiereToClasse(selectedClass.codClass!, 0);
                    refresh();
                  }
                },
                classe: null,
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
