import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import your actual views and controllers
import 'views/welcome_view.dart';
import 'views/signin_view.dart';
import 'views/signup_view.dart';
import 'views/profile_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduNexus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const RootNavigator(),
    );
  }
}

class RootNavigator extends StatefulWidget {
  const RootNavigator({super.key});
  @override
  State<RootNavigator> createState() => _RootNavigatorState();
}

class _RootNavigatorState extends State<RootNavigator> {
  String _currentRoute = 'welcome';

  @override
  void initState() {
    super.initState();
    // Check if user is already signed in and update route accordingly
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _currentRoute = 'profile';
    }
  }

  void _goTo(String route) {
    if (mounted) {
      setState(() {
        _currentRoute = route;
      });
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    _goTo('welcome');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        return Navigator(
          pages: [
            if (user == null && _currentRoute == 'welcome')
              MaterialPage(child: WelcomeView(
                onSignIn: () => _goTo('signin'),
                onSignUp: () => _goTo('signup'),
                onAboutUs: () => _goTo('about'),
              )),
            if (user == null && _currentRoute == 'signin')
              MaterialPage(child: SignInView(
                onBack: () => _goTo('welcome'),
                onSignUp: () => _goTo('signup'),
                onSignedIn: () => _goTo('profile'),
              )),
            if (user == null && _currentRoute == 'signup')
              MaterialPage(child: SignUpView(
                onBack: () => _goTo('welcome'),
                onSignIn: () => _goTo('signin'),
              )),
            if (user != null && _currentRoute == 'profile')
              const MaterialPage(child: ProfileView()),
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }
            if (user == null) {
              _goTo('welcome');
            } else {
              _goTo('profile');
            }
            return true;
          },
        );
      },
    );
  }
}
