import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_example/auth/signup_screen.dart';
import 'package:firebase_example/ui/list_screen.dart';
import 'package:firebase_example/widgets/rounded%20button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passFocusNode = FocusNode();
  bool obscurePass = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'VariableFont',
                  color: Colors.pink.shade300),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none)),
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
                  hintText: 'Password',
                  hintStyle: TextStyle(
                      color: Colors.pink.shade300,
                      fontFamily: 'VariableFont',
                      fontWeight: FontWeight.w600),
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.pink.shade300,
                  ),
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
                  filled: true,
                  fillColor: Colors.pink.shade50,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Colors.pink.shade300,
                          fontFamily: 'VariableFont',
                          fontWeight: FontWeight.w600),
                    )),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            RoundedButton(
              onTap: () async {
                var email = emailController.text.toString();
                var pass = passwordController.text.toString();
                setState(() {
                  loading = true;
                });
                if (email.isEmpty || pass.isEmpty) {
                  Fluttertoast.showToast(
                      backgroundColor: Colors.pink.shade300,
                      msg: 'Please fill all fields');
                  setState(() {
                    loading = false;
                  });
                  return;
                }
                try {
                  final auth = FirebaseAuth.instance;
                  UserCredential userCredential =
                  await auth.signInWithEmailAndPassword(
                      email: emailController.text.toString(),
                      password: passwordController.text.toString());
                  setState(() {
                    loading = true;
                  });
                  if (userCredential.user != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ListScreen()));
                    setState(() {
                      loading = false;
                    });
                  }
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    loading = true;
                  });
                  if (e.code == 'user-not-found') {
                    Fluttertoast.showToast(
                        backgroundColor: Colors.pink.shade300,
                        msg: 'User not found');
                    setState(() {
                      loading = false;
                    });
                  } else if (e.code == 'wrong-password') {
                    Fluttertoast.showToast(
                        backgroundColor: Colors.pink.shade300,
                        msg: 'Wrong password');
                    setState(() {
                      loading = false;
                    });
                  }
                } catch (e) {
                  Fluttertoast.showToast(
                      backgroundColor: Colors.pink.shade300,
                      msg: 'Something went wrong');
                }
              },
              title: 'Login',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Not yet register? ',
                  style: TextStyle(
                      fontFamily: 'VariableFont', fontWeight: FontWeight.w600),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                        fontFamily: 'VariableFont',
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade300,
                        fontSize: 15),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
