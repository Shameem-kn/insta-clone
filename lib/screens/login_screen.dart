import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instaclone_ranavat/resources/auth_methods.dart';
import 'package:instaclone_ranavat/responsive/mobile_screen_layout.dart';
import 'package:instaclone_ranavat/responsive/responsive_layout_screen.dart';
import 'package:instaclone_ranavat/responsive/web_screen_layout.dart';
import 'package:instaclone_ranavat/screens/signup_screen.dart';
import 'package:instaclone_ranavat/utils/colors.dart';
import 'package:instaclone_ranavat/utils/global_variables.dart';
import 'package:instaclone_ranavat/utils/utils.dart';
import 'package:instaclone_ranavat/widgets/text_field.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    PasswordController.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: emailController.text, password: PasswordController.text);
    setState(() {
      isLoading = false;
    });

    if (res == "success") {
      // go to home page
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));

      showSnackBar(res, context);
    } else {
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: MediaQuery.of(context).size.width > webScreenSize
          ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 3)
          : const EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Container(),
          ),
          // svg image
          SvgPicture.asset(
            "assets/images/instagram.svg",
            color: primaryColor,
            height: 64,
          ),

          // textfield for email
          const SizedBox(height: 60),
          TextFieldInput(
              textEditingController: emailController,
              hintText: "EMAIL",
              textInputType: TextInputType.emailAddress),
          // text feild for password
          const SizedBox(height: 15),
          TextFieldInput(
              textEditingController: PasswordController,
              hintText: "PASSWORD",
              isPass: true,
              textInputType: TextInputType.text),
          // text button
          const SizedBox(height: 15),
          Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const ShapeDecoration(
                color: blueColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
              child: GestureDetector(
                  onTap: loginUser,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: primaryColor,
                        ))
                      : const Text("Login"))),
          // signup page
          const SizedBox(height: 15),
          Flexible(
            flex: 2,
            child: Container(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
                child: const Text("Don't have an account?"),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const SignupScreen()));
                },
                child: Container(
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    )));
  }
}
