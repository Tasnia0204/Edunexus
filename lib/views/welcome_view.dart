import 'package:flutter/material.dart';
import 'login_view.dart';
import 'signup_view.dart';
import 'aboutus_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              right: 10,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutUsView()),
                  );
                },
                child: const Text(
                  'About Us',
                  style: TextStyle(color: Color(0xFF334EAC)),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  Image.asset('assets/logo.png', width: 100, height: 100),
                  const SizedBox(height: 10),
                  const Text(
                    'EduNexus',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF081F5C),
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      'Welcome to EduNexus! Connect, Share, and Grow with student-powered learning.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const Spacer(),
                  // Changed Row to Column, made buttons larger, added splash color
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 160,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            splashFactory: InkRipple.splashFactory,
                            overlayColor: WidgetStateProperty.resolveWith<Color?>(
                              (states) => states.contains(WidgetState.pressed)
                                  ? const Color(0xFF7096D1)
                                  : null,
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginView()),
                          ),
                          child: const Text('Log In'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 160,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            splashFactory: InkRipple.splashFactory,
                            overlayColor: WidgetStateProperty.resolveWith<Color?>(
                              (states) => states.contains(WidgetState.pressed)
                                  ? const Color(0xFF7096D1)
                                  : null,
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SignupView()),
                          ),
                          child: const Text('Sign Up'),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
