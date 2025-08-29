// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:text_form_field_wrapper/text_form_field_wrapper.dart';
import '../../../widgets/app_button.dart';
import '../controllers/auth_controller.dart';

class GoogleAuthView extends StatelessWidget {
  GoogleAuthView({super.key});
  final AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 110,
                    ),
                    const Text(
                      'Welcome back!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Please, sign in to continue',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormFieldWrapper(
                      borderFocusedColor: const Color(0xFFCB2D3C),
                      formField: TextFormField(
                        controller: controller.email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            label: Text('Enter Email'),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.email)),
                      ),
                      position: TextFormFieldPosition.alone,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormFieldWrapper(
                      borderFocusedColor: const Color(0xFFCB2D3C),
                      formField: TextFormField(
                        controller: controller.password,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                            label: Text('Enter Password'),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.password)),
                      ),
                      position: TextFormFieldPosition.alone,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppButton(
                      title: 'Sign In',
                      onTap: () {
                        controller.login();
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () => controller.resetPassword(),
                          child: const Text(
                            'Forgot Your Password?',
                            style: TextStyle(color: Colors.grey),
                          )),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        const Text('OR'),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SimpleShadow(
                      opacity: 0.1,
                      child: SocialLoginButton(
                        borderRadius: 12,
                        height: 70,
                        buttonType: SocialLoginButtonType.google,
                        text: 'Start With Google',
                        onPressed: () => controller.signInWithGoogle(),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      'Powered by App Seba - Your Trusted Friend',
                    ),
                    const Text(
                      'Software Company',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
