import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_example/ui/add_tasks.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'description_screen.dart';
import 'profile_screen.dart';
import '../auth/login_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key,});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  CollectionReference? taskRef;
  bool loading = false;
  final updateController = TextEditingController();
  final desController = TextEditingController();
  final searchController = TextEditingController();
  final titleFocusNode = FocusNode();
  final desFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    taskRef = FirebaseFirestore.instance
        .collection('Tasks')
        .doc(uid)
        .collection('Tasks');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade300,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreens()));
              },
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Confirmation',
                          style: TextStyle(fontFamily: 'VariableFont'),
                        ),
                        content: const Text(
                          'Are you sure to Logout?',
                          style: TextStyle(fontFamily: 'VariableFont'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                  fontFamily: 'VariableFont',
                                  color: Colors.pink.shade300),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'No',
                              style: TextStyle(
                                  fontFamily: 'VariableFont',
                                  color: Colors.pink.shade300),
                            ),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              )),
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Task List',
          style: TextStyle(fontFamily: 'VariableFont', color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: SizedBox(
              height: 50,
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                    hintText: 'Search here...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                    filled: true,
                    fillColor: Colors.pink.shade50,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20))),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: taskRef!.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Task Added Yet',
                      style: TextStyle(fontFamily: 'VariableFont'),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final title = snapshot.data!.docs[index]['Task Name'];
                          if (searchController.text.isEmpty) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DescriptionScreen()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 18),
                                child: Card(
                                  color: Colors.pink.shade50,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: ListTile(
                                    minVerticalPadding: 7,
                                    title: Text(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      'Title:' +
                                          snapshot.data!.docs[index]
                                              ['Task Name'],
                                      style: const TextStyle(
                                          fontFamily: 'VariableFont',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ignore: prefer_interpolation_to_compose_strings
                                        Text(
                                          'Des:' +
                                              snapshot.data!.docs[index]
                                                  ['Description'],
                                          style: const TextStyle(
                                              fontFamily: 'VariableFont',
                                              fontSize: 12,
                                              overflow: TextOverflow.ellipsis,
                                              decorationStyle:
                                                  TextDecorationStyle.dotted),
                                          maxLines: 1,
                                        ),
                                        Text(
                                          dateTimeReadable(
                                            snapshot.data!.docs[index]['dt'],
                                          ),
                                          style: const TextStyle(
                                              fontFamily: 'VariableFont',
                                              fontSize: 11),
                                        ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Card(
                                          child: PopupMenuButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem(
                                                      value: 2,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Update',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'VariableFont',
                                                                      )),
                                                                  content:
                                                                      Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      TextFormField(
                                                                        controller:
                                                                            updateController,
                                                                        focusNode:
                                                                            titleFocusNode,
                                                                        decoration: InputDecoration(
                                                                            hintText: snapshot.data!.docs[index]['Task Name'],
                                                                            hintStyle: TextStyle(color: Colors.pink.shade400, fontFamily: 'VariableFont', fontSize: 15),
                                                                            filled: true,
                                                                            fillColor: Colors.pink.shade50,
                                                                            border: OutlineInputBorder(
                                                                              borderSide: BorderSide.none,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                                                                        onFieldSubmitted:
                                                                            (value) {
                                                                          FocusScope.of(context)
                                                                              .requestFocus(desFocusNode);
                                                                        },
                                                                      ),
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.02,
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            100,
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.9,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.pink.shade50,
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(bottom: 20),
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                desController,
                                                                            focusNode:
                                                                                desFocusNode,
                                                                            minLines:
                                                                                2,
                                                                            maxLines:
                                                                                5,
                                                                            keyboardType:
                                                                                TextInputType.multiline,
                                                                            decoration: InputDecoration(
                                                                                hintText: snapshot.data!.docs[index]['Description'],
                                                                                hintStyle: TextStyle(color: Colors.pink.shade400, fontFamily: 'VariableFont', fontSize: 15),
                                                                                filled: true,
                                                                                fillColor: Colors.pink.shade50,
                                                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  actions: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            taskRef!.doc(snapshot.data!.docs[index]['taskId']).update({
                                                                              'Task Name': updateController.text,
                                                                              'Description': desController.text
                                                                            });
                                                                            updateController.clear();
                                                                            desController.clear();
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                40,
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.28,
                                                                            decoration:
                                                                                BoxDecoration(color: Colors.pink.shade300, borderRadius: BorderRadius.circular(10)),
                                                                            child:
                                                                                Center(
                                                                              child: loading
                                                                                  ? const CircularProgressIndicator(color: Colors.white)
                                                                                  : const Text(
                                                                                      'Update',
                                                                                      style: TextStyle(fontFamily: 'VariableFont', fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
                                                                                    ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                40,
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.25,
                                                                            decoration:
                                                                                BoxDecoration(color: Colors.pink.shade300, borderRadius: BorderRadius.circular(10)),
                                                                            child:
                                                                                Center(
                                                                              child: loading
                                                                                  ? const CircularProgressIndicator(color: Colors.white)
                                                                                  : const Text(
                                                                                      'Cancel',
                                                                                      style: TextStyle(fontFamily: 'VariableFont', fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
                                                                                    ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Edit',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'VariableFont'),
                                                            ),
                                                            Container(
                                                                height: 40,
                                                                width: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .green,
                                                                ))
                                                          ],
                                                        ),
                                                      )),
                                                  PopupMenuItem(
                                                      value: 1,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          showDialog(
                                                              context:
                                                                  (context),
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              30,
                                                                          left:
                                                                              22),
                                                                  content:
                                                                      const Text(
                                                                    'Are your sure to delete',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'VariableFont'),
                                                                  ),
                                                                  title:
                                                                      const Text(
                                                                    'Confirmation',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'VariableFont',
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (taskRef !=
                                                                            null) {
                                                                          taskRef!
                                                                              .doc(snapshot.data!.docs[index]['taskId'])
                                                                              .delete();
                                                                          Navigator.pop(
                                                                              context);
                                                                        }
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Yes',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'VariableFont',
                                                                            color:
                                                                                Colors.pink.shade300),
                                                                      ),
                                                                    ),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'No',
                                                                          style: TextStyle(
                                                                              fontFamily: 'VariableFont',
                                                                              color: Colors.pink.shade300),
                                                                        )),
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'VariableFont'),
                                                            ),
                                                            Container(
                                                                height: 40,
                                                                width: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .pink
                                                                      .shade300,
                                                                )),
                                                          ],
                                                        ),
                                                      ))
                                                ];
                                              }),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else if (title.toLowerCase().contains(
                              searchController.text
                                  .toUpperCase()
                                  .toLowerCase())) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DescriptionScreen()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 18),
                                child: Card(
                                  color: Colors.pink.shade50,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: ListTile(
                                    minVerticalPadding: 7,
                                    title: Text(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      'Title:' +
                                          snapshot.data!.docs[index]
                                              ['Task Name'],
                                      style: const TextStyle(
                                          fontFamily: 'VariableFont',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ignore: prefer_interpolation_to_compose_strings
                                        Text(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          'Des:' +
                                              snapshot.data!.docs[index]
                                                  ['Description'],
                                          style: const TextStyle(
                                              fontFamily: 'VariableFont',
                                              fontSize: 12,
                                              overflow: TextOverflow.ellipsis,
                                              decorationStyle:
                                                  TextDecorationStyle.dotted),
                                          maxLines: 1,
                                        ),
                                        Text(
                                          dateTimeReadable(
                                            snapshot.data!.docs[index]['dt'],
                                          ),
                                          style: const TextStyle(
                                              fontFamily: 'VariableFont',
                                              fontSize: 11),
                                        ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Card(
                                          child: PopupMenuButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem(
                                                      value: 2,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Update',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'VariableFont',
                                                                      )),
                                                                  content:
                                                                      Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      TextFormField(
                                                                        controller:
                                                                            updateController,
                                                                        focusNode:
                                                                            titleFocusNode,
                                                                        decoration: InputDecoration(
                                                                            hintText: snapshot.data!.docs[index]['Task Name'],
                                                                            hintStyle: TextStyle(color: Colors.pink.shade400, fontFamily: 'VariableFont', fontSize: 15),
                                                                            filled: true,
                                                                            fillColor: Colors.pink.shade50,
                                                                            border: OutlineInputBorder(
                                                                              borderSide: BorderSide.none,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                                                                        onFieldSubmitted:
                                                                            (value) {
                                                                          FocusScope.of(context)
                                                                              .requestFocus(desFocusNode);
                                                                        },
                                                                      ),
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.02,
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            100,
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.9,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.pink.shade50,
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(bottom: 20),
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                desController,
                                                                            focusNode:
                                                                                desFocusNode,
                                                                            minLines:
                                                                                2,
                                                                            maxLines:
                                                                                5,
                                                                            keyboardType:
                                                                                TextInputType.multiline,
                                                                            decoration: InputDecoration(
                                                                                hintText: snapshot.data!.docs[index]['Description'],
                                                                                hintStyle: TextStyle(color: Colors.pink.shade400, fontFamily: 'VariableFont', fontSize: 15),
                                                                                filled: true,
                                                                                fillColor: Colors.pink.shade50,
                                                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  actions: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            taskRef!.doc(snapshot.data!.docs[index]['taskId']).update({
                                                                              'Task Name': updateController.text,
                                                                              'Description': desController.text
                                                                            });
                                                                            updateController.clear();
                                                                            desController.clear();
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                40,
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.28,
                                                                            decoration:
                                                                                BoxDecoration(color: Colors.pink.shade300, borderRadius: BorderRadius.circular(10)),
                                                                            child:
                                                                                Center(
                                                                              child: loading
                                                                                  ? const CircularProgressIndicator(color: Colors.white)
                                                                                  : const Text(
                                                                                      'Update',
                                                                                      style: TextStyle(fontFamily: 'VariableFont', fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
                                                                                    ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                40,
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.25,
                                                                            decoration:
                                                                                BoxDecoration(color: Colors.pink.shade300, borderRadius: BorderRadius.circular(10)),
                                                                            child:
                                                                                Center(
                                                                              child: loading
                                                                                  ? const CircularProgressIndicator(color: Colors.white)
                                                                                  : const Text(
                                                                                      'Cancel',
                                                                                      style: TextStyle(fontFamily: 'VariableFont', fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
                                                                                    ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Edit',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'VariableFont'),
                                                            ),
                                                            Container(
                                                                height: 40,
                                                                width: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .green,
                                                                ))
                                                          ],
                                                        ),
                                                      )),
                                                  PopupMenuItem(
                                                      value: 1,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          showDialog(
                                                              context:
                                                                  (context),
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              30,
                                                                          left:
                                                                              22),
                                                                  content:
                                                                      const Text(
                                                                    'Are your sure to delete',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'VariableFont'),
                                                                  ),
                                                                  title:
                                                                      const Text(
                                                                    'Confirmation',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'VariableFont',
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (taskRef !=
                                                                            null) {
                                                                          taskRef!
                                                                              .doc(snapshot.data!.docs[index]['taskId'])
                                                                              .delete();
                                                                          Navigator.pop(
                                                                              context);
                                                                        }
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Yes',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'VariableFont',
                                                                            color:
                                                                                Colors.pink.shade300),
                                                                      ),
                                                                    ),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'No',
                                                                          style: TextStyle(
                                                                              fontFamily: 'VariableFont',
                                                                              color: Colors.pink.shade300),
                                                                        )),
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'VariableFont'),
                                                            ),
                                                            Container(
                                                                height: 40,
                                                                width: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .pink
                                                                      .shade300,
                                                                )),
                                                          ],
                                                        ),
                                                      ))
                                                ];
                                              }),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {}
                          return null;
                        }),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.pink.shade300,
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink.shade300,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTask()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  String dateTimeReadable(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);
    return DateFormat('hh:mm dd-MM-yyyy ').format(dateTime);
  }
}
