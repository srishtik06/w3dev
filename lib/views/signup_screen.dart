import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/signin_screen.dart';
import '../themes/app_theme.dart';
import '../widgets/custom_scaffold.dart';
import '../viewmodels/sign_up_view_model.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sheight = MediaQuery.of(context).size.height;
    final swidth = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: Consumer<SignUpViewModel>(
        builder: (context, viewModel, _) {
          return CustomScaffold(
            child: Column(
              children: [
                Spacer(flex: 1),
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: swidth * 0.06,
                      vertical: sheight * 0.05,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(swidth * 0.1),
                        topRight: Radius.circular(swidth * 0.1),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: swidth * 0.08,
                                fontWeight: FontWeight.w900,
                                color: lightColorScheme.primary,
                              ),
                            ),
                            SizedBox(height: sheight * 0.04),
                            _buildTextField(
                              viewModel.fullNameController,
                              'Full Name',
                              'Enter Full Name',
                              errorText: viewModel.fullNameError,
                            ),
                            _buildTextField(
                              viewModel.emailController,
                              'Email',
                              'Enter Email',
                              errorText: viewModel.emailError,
                            ),
                            _buildTextField(
                              viewModel.passwordController,
                              'Password',
                              'Enter Password',
                              obscureText: true,
                              errorText: viewModel.passwordError,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: viewModel.agreePersonalData,
                                  onChanged: (bool? value) {
                                    viewModel.agreePersonalData = value!;
                                  },
                                  activeColor: lightColorScheme.primary,
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.black45),
                                      children: [
                                        TextSpan(text: 'I agree to the processing of '),
                                        TextSpan(
                                          text: 'Personal data',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: lightColorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            _buildButton('Sign up', () => viewModel.signUp(context)),
                            _buildButton('Sign in with Google', () => viewModel.signInWithGoogle(context), color: Colors.red),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Already have an account? ', style: TextStyle(color: Colors.black45)),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (e) => const SignInScreen()),
                                  ),
                                  child: Text(
                                    'Sign in',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: lightColorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      String hint,
      {bool obscureText = false, String? errorText}
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        obscuringCharacter: '*',
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black26),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.circular(10),
          ),
          errorText: errorText,  // Display error dynamically
        ),
      ),
    );
  }


  Widget _buildButton(String text, VoidCallback onPressed, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(text),
          style: ElevatedButton.styleFrom(backgroundColor: color ?? lightColorScheme.primary),
        ),
      ),
    );
  }
}
