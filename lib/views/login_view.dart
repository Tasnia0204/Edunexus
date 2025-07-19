import 'package:flutter/material.dart';

import 'profile_view.dart';
import 'signup_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 80),
            const Text('EduNexus', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF334EAC)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF334EAC)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('Forgot Password?'),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ButtonStyle(
                splashFactory: InkRipple.splashFactory,
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) => states.contains(WidgetState.pressed)
                      ? const Color(0xFF7096D1)
                      : null,
                ),
              ),
              onPressed: () {
                final email = emailController.text.trim();
                final pass = passController.text;
                if (email.isEmpty || pass.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter email and password.')),
                  );
                } else if (email == "tasnia0204@gmail.com" && pass == "hello1234") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileView()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email or password is incorrect.')),
                  );
                }
              },
              child: const Text('Log In'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Not have an account? '),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignupView())),
                  child: const Text('Sign Up'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}