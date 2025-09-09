import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key, required this.onSignIn, required this.onSignUp, required this.onAboutUs});

  final VoidCallback onSignIn;
  final VoidCallback onSignUp;
  final VoidCallback onAboutUs;

  @override
  Widget build(BuildContext context) {
    // Color palette
    const Color darkBlue = Color(0xFF081F5C);
    const Color blue = Color(0xFF334EAC);
    const Color lightBlue = Color(0xFF7096D1);
    const Color veryLightBlue = Color(0xFFD0E3FF);
    const Color paleBlue = Color(0xFFE7F1FF);
    const Color almostWhite = Color(0xFFF9FCFF);

    return Scaffold(
      backgroundColor: darkBlue,
      appBar: AppBar(
        backgroundColor: darkBlue,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: onAboutUs,
              child: const Text('About Us', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  'EduNexus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'Welcome to EduNexus!\n\nConnect, collaborate, and grow your knowledge. Join groups, find peers, and manage your learning journey all in one place.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: veryLightBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blue,
                            foregroundColor: darkBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: onSignIn,
                          child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: veryLightBlue,
                            foregroundColor: blue,
                            side: BorderSide(color: blue, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: onSignUp,
                          child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF334EAC))),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
