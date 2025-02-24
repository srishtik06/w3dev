import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sign_in_view_model.dart';
import 'signup_screen.dart';
import '../themes/app_theme.dart';
import '../widgets/custom_scaffold.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sheight = MediaQuery.of(context).size.height;
    final swidth = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (_) => SignInViewModel(),
      child: Consumer<SignInViewModel>(
        builder: (context, viewModel, child) {
          return CustomScaffold(
            child: Column(
              children: [
                Spacer(flex: 1),
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(swidth * 0.07, sheight * 0.07, swidth * 0.07, sheight * 0.03),
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
                              'Welcome back',
                              style: TextStyle(
                                fontSize: sheight * 0.04,
                                fontWeight: FontWeight.w900,
                                color: lightColorScheme.primary,
                              ),
                            ),
                            SizedBox(height: sheight * 0.05),
                            TextField(
                              controller: viewModel.emailController,
                              onChanged: viewModel.validateEmail,
                              decoration: _buildInputDecoration('Email', 'Enter Email'),
                            ),
                            if (viewModel.emailError != null)
                              _buildErrorText(viewModel.emailError!),
                            SizedBox(height: sheight * 0.03),
                            TextField(
                              controller: viewModel.passwordController,
                              obscureText: true,
                              obscuringCharacter: '*',
                              onChanged: viewModel.validatePassword,
                              decoration: _buildInputDecoration('Password', 'Enter Password'),
                            ),
                            if (viewModel.passwordError != null)
                              _buildErrorText(viewModel.passwordError!),
                            SizedBox(height: sheight * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: viewModel.rememberPassword,
                                      onChanged: (bool? value) {
                                        viewModel.rememberPassword = value!;
                                      },
                                      activeColor: lightColorScheme.primary,
                                    ),
                                    const Text('Remember me', style: TextStyle(color: Colors.black45)),
                                  ],
                                ),
                                GestureDetector(
                                  child: Text(
                                    'Forget password?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: lightColorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: sheight * 0.03),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await viewModel.signIn(context);
                                },
                                child: const Text('Sign In'),
                              ),
                            ),
                            SizedBox(height: sheight * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account? ", style: TextStyle(color: Colors.black45)),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (e) => const SignUpScreen()),
                                    );
                                  },
                                  child: Text(
                                    'Sign up',
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

  InputDecoration _buildInputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black26),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildErrorText(String error) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        error,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
