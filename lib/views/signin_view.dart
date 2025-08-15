import 'package:flutter/material.dart';
import '../controllers/signin_controller.dart';
import '../models/app_colors.dart';

class SignInView extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSignUp;
  final VoidCallback onSignedIn;
  const SignInView({super.key, required this.onBack, required this.onSignUp, required this.onSignedIn});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final SignInController _controller = SignInController();
  bool _loading = false;
  String _error = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: widget.onBack,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Image.asset('assets/logo.png', height: 80),
              const SizedBox(height: 16),
              const Text('EduNexus', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 32),
              Form(
                key: _controller.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _controller.emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: AppColors.blue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value == null || value.isEmpty ? 'Enter your email' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _controller.passwordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: AppColors.blue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                      obscureText: true,
                      validator: (value) => value == null || value.isEmpty ? 'Enter your password' : null,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          setState(() { _loading = true; });
                          await _controller.forgotPassword(context);
                          setState(() {
                            _error = _controller.error;
                            _loading = false;
                          });
                        },
                        child: const Text('Forgot password?', style: TextStyle(color: AppColors.veryLightBlue)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_error.isNotEmpty)
                      Text(_error, style: const TextStyle(color: Colors.redAccent)),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          foregroundColor: AppColors.darkBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _loading ? null : () async {
                          if (_controller.formKey.currentState?.validate() ?? false) {
                            setState(() { _loading = true; _error = ''; });
                            final success = await _controller.signIn(context);
                            setState(() {
                              _error = _controller.error;
                              _loading = false;
                            });
                            // if (success) widget.onSignedIn();
                            if (success) {
                        Navigator.pushReplacementNamed(context, '/profile');
                      }
                          }
                        },
                        child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? ", style: TextStyle(color: AppColors.veryLightBlue)),
                        TextButton(
                          onPressed: widget.onSignUp,
                          child: const Text('Sign Up', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
