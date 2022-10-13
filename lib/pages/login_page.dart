import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/signup.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:chat_app/constants.dart';

import 'package:chat_app/helper/show_snack_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

String? email;
String? password;

bool isLoading = false;

GlobalKey<FormState> formKey = GlobalKey();

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formKey,
            child: ListView(children: [
              const SizedBox(
                height: 75,
              ),
              Image.asset(
                'assets/images/scholar.png',
                height: 100,
              ),
              Text(
                'Scholar Chat',
                style: GoogleFonts.pacifico(
                  fontSize: 32,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 75,
              ),
              const Text(
                'LOGIN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomFormTextField(
                hintText: 'Email',
                onChanged: (data) {
                  email = data;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              CustomFormTextField(
                obscureText: true,
                hintText: 'Password',
                onChanged: (data) {
                  password = data;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                text: 'LOGIN',
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    isLoading = true;
                    setState(() {});
                    try {
                      await loginUser();
                      Navigator.pushNamed(context, ChatPage.id,
                          arguments: email);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        showSnackBar(context, 'No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        showSnackBar(
                            context, 'Wrong password provided for that user.');
                      }
                    } catch (e) {
                      showSnackBar(context, e.toString());
                    }
                    isLoading = false;
                    setState(() {});
                  } else {}
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'dont have an account ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SiginUp.id);
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xffC7EDE6),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
