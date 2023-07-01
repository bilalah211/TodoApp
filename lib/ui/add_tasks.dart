import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_example/ui/list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final taskNameController = TextEditingController();
  final desController = TextEditingController();
  final nameFocusNode = FocusNode();
  final desFocusNode = FocusNode();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.pink.shade300,
        leading: InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const ListScreen()));
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        centerTitle: true,
        title: const Text(
          'Add Task',
          style: TextStyle(fontFamily: 'VariableFont', color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: taskNameController,
              focusNode: nameFocusNode,
              decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(
                      color: Colors.pink.shade300,
                      fontFamily: 'VariableFont',
                      fontWeight: FontWeight.w600),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.pink.shade300,
                  ),
                  filled: true,
                  fillColor: Colors.pink.shade50,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none)),
              onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(desFocusNode);
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: desController,
                  focusNode: desFocusNode,
                  maxLines: 20,
                  minLines: 2,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      hintText: 'Description',
                      hintStyle: TextStyle(
                          color: Colors.pink.shade300,
                          fontFamily: 'VariableFont',
                          fontWeight: FontWeight.w600),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Icon(
                          Icons.description,
                          color: Colors.pink.shade300,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.pink.shade50,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none)),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  loading = true;
                });
                var taskName = taskNameController.text.toString();
                var des = desController.text.toString();

                if (taskName.isEmpty || des.isEmpty) {
                  setState(() {
                    loading = true;
                  });
                  Fluttertoast.showToast(
                      backgroundColor: Colors.pink.shade300,
                      msg: 'Please filled both the fields');
                  setState(() {
                    loading = false;
                  });
                } else {
                  String uid = FirebaseAuth.instance.currentUser!.uid;

                  if (uid != null) {
                    int dt = DateTime.now().millisecondsSinceEpoch;
                    final taskRef = FirebaseFirestore.instance
                        .collection('Tasks')
                        .doc(uid)
                        .collection('Tasks')
                        .doc();
                    taskRef.set({
                      'Task Name': taskName,
                      'Description': des,
                      'dt': dt,
                      'taskId': taskRef.id
                    });
                    Fluttertoast.showToast(
                        backgroundColor: Colors.pink.shade300,
                        msg: 'Task Added');
                    taskNameController.clear();
                    desController.clear();
                    setState(() {
                      loading = false;
                    });
                  }
                }
              },
              child: Container(
                height: 40,
                width: 220,
                decoration: BoxDecoration(
                    color: Colors.pink.shade200,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save',
                          style: TextStyle(
                              fontFamily: 'VariableFont',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
