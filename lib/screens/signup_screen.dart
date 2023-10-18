import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone_ranavat/resources/auth_methods.dart';
import 'package:instaclone_ranavat/screens/login_screen.dart';
import 'package:instaclone_ranavat/utils/colors.dart';
import 'package:instaclone_ranavat/utils/utils.dart';
import 'package:instaclone_ranavat/widgets/text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List selectedImage = await pickImage(ImageSource.gallery);
    setState(() {
      _image = selectedImage;
    });
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      isLoading = false;
    });

    if (res != "success") {
      showSnackBar(res, context);
    } else {
      showSnackBar("success", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            // svg image
            SvgPicture.asset(
              "assets/images/instagram.svg",
              color: primaryColor,
              height: 64,
            ),
            const SizedBox(height: 10),
            // circle avatar to accept selected file
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64, backgroundImage: MemoryImage(_image!))
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg"),
                      ),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo)))
              ],
            ),

            const SizedBox(height: 24),
            // textfield for username

            TextFieldInput(
                textEditingController: _usernameController,
                hintText: "Username",
                textInputType: TextInputType.text),
            const SizedBox(height: 24),
            // textfield for email

            TextFieldInput(
                textEditingController: _emailController,
                hintText: "Email",
                textInputType: TextInputType.emailAddress),
            const SizedBox(height: 24),
            // text feild for password

            TextFieldInput(
                textEditingController: _passwordController,
                hintText: "Password",
                isPass: true,
                textInputType: TextInputType.text),
            const SizedBox(height: 24),
            // textfield for bio

            TextFieldInput(
                textEditingController: _bioController,
                hintText: "Bio",
                textInputType: TextInputType.text),
            const SizedBox(height: 24),
            // text button
            InkWell(
              onTap: signUpUser,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  color: blueColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                ),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: primaryColor,
                      ))
                    : const Text("Signup"),
              ),
            ),
            const SizedBox(height: 15),
            // signup page

            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
                  child: const Text("Already have an account?"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Loginscreen()));
                  },
                  child: Container(
                    padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
                    child: const Text(
                      "Log in",
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
      ),
    )));
  }
}
