import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DescriptionScreen extends StatefulWidget {
  const DescriptionScreen({super.key,});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  DocumentSnapshot? taskRef;

  getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    taskRef =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
          color: Colors.pink.shade50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  taskRef!['Full Name'],
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
      ),
    ),
        ));
  }
}
