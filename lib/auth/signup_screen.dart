import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final auth = FirebaseAuth.instance;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cPasswordController = TextEditingController();
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passFocusNode = FocusNode();
  final cPassFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool obscurePass = true;
  bool obscurePasss = true;
  bool loading = false;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Text(
                          'Sign up',
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'VariableFont',
                              color: Colors.pink.shade300),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.09,
                        ),
                        TextFormField(
                          controller: nameController,
                          focusNode: nameFocusNode,
                          decoration: InputDecoration(
                              hintText: 'Full Name',
                              hintStyle: TextStyle(
                                  color: Colors.pink.shade300,
                                  fontFamily: 'VariableFont',
                                  fontWeight: FontWeight.w600),
                              prefixIcon: Icon(
                                Icons.person_2,
                                color: Colors.pink.shade300,
                              ),
                              filled: true,
                              fillColor: Colors.pink.shade50,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter your full name';
                            }
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(emailFocusNode);
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        TextFormField(
                          controller: emailController,
                          focusNode: emailFocusNode,
                          decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                  color: Colors.pink.shade300,
                                  fontFamily: 'VariableFont',
                                  fontWeight: FontWeight.w600),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.pink.shade300,
                              ),
                              filled: true,
                              fillColor: Colors.pink.shade50,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter your Email';
                            }
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(passFocusNode);
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        TextFormField(
                          controller: passwordController,
                          focusNode: passFocusNode,
                          obscureText: obscurePass,
                          decoration: InputDecoration(
                              suffixIcon: InkWell(
                                  onTap: () {
                                    obscurePass = !obscurePass;
                                    setState(() {});
                                  },
                                  child: obscurePass
                                      ? Icon(
                                          Icons.visibility_off,
                                          color: Colors.pink.shade300,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                          color: Colors.pink.shade300,
                                        )),
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                  color: Colors.pink.shade300,
                                  fontFamily: 'VariableFont',
                                  fontWeight: FontWeight.w600),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.pink.shade300,
                              ),
                              filled: true,
                              fillColor: Colors.pink.shade50,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter your Password';
                            }
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(cPassFocusNode);
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        TextFormField(
                          obscureText: obscurePasss,
                          controller: cPasswordController,
                          focusNode: cPassFocusNode,
                          decoration: InputDecoration(
                              suffixIcon: InkWell(
                                  onTap: () {
                                    obscurePasss = !obscurePasss;
                                    setState(() {});
                                  },
                                  child: obscurePasss
                                      ? Icon(
                                          Icons.visibility_off,
                                          color: Colors.pink.shade300,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                          color: Colors.pink.shade300,
                                        )),
                              hintText: 'Confirm Password',
                              hintStyle: TextStyle(
                                  color: Colors.pink.shade300,
                                  fontFamily: 'VariableFont',
                                  fontWeight: FontWeight.w600),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.pink.shade300,
                              ),
                              filled: true,
                              fillColor: Colors.pink.shade50,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter password again';
                            }
                            return null;
                          },
                        ),
                      ],
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
                InkWell(
                  onTap: () async {
                    var fullName = nameController.text.toString();
                    var email = emailController.text.toString();
                    var pass = passwordController.text.toString();
                    var cPass = cPasswordController.text.toString();

                    setState(() {
                      loading = true;
                    });

                    if (fullName.isEmpty ||
                        email.isEmpty ||
                        pass.isEmpty ||
                        cPass.isEmpty) {
                      // show error toast

                      Fluttertoast.showToast(
                          backgroundColor: Colors.pink.shade300,
                          msg: 'Please fill all fields');
                      setState(() {
                        loading = false;
                      });
                      return;
                    }

                    if (pass.length < 6) {
                      // show error toast
                      Fluttertoast.showToast(
                          backgroundColor: Colors.pink.shade300,
                          msg:
                              'Weak Password, at least 6 characters are required');
                      setState(() {
                        loading = false;
                      });

                      return;
                    }

                    if (pass != cPass) {
                      // show error toast
                      Fluttertoast.showToast(
                          backgroundColor: Colors.pink.shade300,
                          msg: 'Passwords do not match');
                      setState(() {
                        loading = false;
                      });

                      return;
                    }

                    try {
                      final auth = FirebaseAuth.instance;
                      UserCredential userCredential =
                          await auth.createUserWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: passwordController.text.toString());
                      if (userCredential.user != null) {
                        final fireStore = FirebaseFirestore.instance;
                        String uid = userCredential.user!.uid;
                        int dt = DateTime.now().millisecondsSinceEpoch;

                        fireStore.collection('Users').doc(uid).set({
                          'Full Name': fullName,
                          'Email': email,
                          'Uid': uid,
                          'dt': dt,
                          'ProfileImage':
                              'https://tse1.mm.bing.net/th?id=OIP.mP1RB8xuQaHAvUkonYY6HwHaHK&pid=Api&P=0&h=180'
                        });
                        Fluttertoast.showToast(
                            backgroundColor: Colors.pink.shade300,
                            msg: 'Account Created');
                        setState(() {
                          loading = false;
                        });
                      } else {}
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        Fluttertoast.showToast(
                            backgroundColor: Colors.pink.shade300,
                            msg: 'Email is already in Use');
                        setState(() {
                          loading = false;
                        });
                      } else if (e.code == 'weak-password') {
                        Fluttertoast.showToast(
                            backgroundColor: Colors.pink.shade300,
                            msg: 'Password is weak');
                        setState(() {
                          loading = false;
                        });
                      }
                    } catch (e) {
                      Fluttertoast.showToast(
                          backgroundColor: Colors.pink.shade300,
                          msg: 'Something went wrong');
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 220,
                    decoration: BoxDecoration(
                        color: Colors.pink.shade300,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: loading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Sign up',
                              style: TextStyle(
                                  fontFamily: 'VariableFont',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Already have an account ',
                            style: TextStyle(
                                fontFamily: 'VariableFont',
                                fontWeight: FontWeight.w600))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
