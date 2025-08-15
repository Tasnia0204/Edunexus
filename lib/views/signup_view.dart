import 'package:flutter/material.dart';
import '../controllers/signup_controller.dart';
import '../models/app_colors.dart';

class SignUpView extends StatefulWidget {
  final VoidCallback onSignIn;
  final VoidCallback onBack;
  const SignUpView({super.key, required this.onSignIn, required this.onBack});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final SignUpController _controller = SignUpController();
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
                      controller: _controller.nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: AppColors.blue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: 20),
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
                    DropdownButtonFormField<String>(
                      value: _controller.department,
                      items: _controller.departments.map((dept) => DropdownMenuItem(
                        value: dept,
                        child: Text(dept, style: const TextStyle(color: Colors.black)),
                      )).toList(),
                      onChanged: (val) => setState(() => _controller.department = val),
                      decoration: InputDecoration(
                        labelText: 'Department',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: AppColors.blue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                      dropdownColor: AppColors.veryLightBlue,
                      validator: (value) => value == null || value.isEmpty ? 'Select department' : null,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<int>(
                      value: _controller.admittedYear,
                      items: _controller.getAdmittedYears().map((year) => DropdownMenuItem(
                        value: year,
                        child: Text(year.toString(), style: const TextStyle(color: Colors.black)),
                      )).toList(),
                      onChanged: (val) => setState(() => _controller.admittedYear = val),
                      decoration: InputDecoration(
                        labelText: 'Admitted Year',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: AppColors.blue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                      dropdownColor: AppColors.veryLightBlue,
                      validator: (value) => value == null ? 'Select year' : null,
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
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _controller.confirmPasswordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
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
                      validator: (value) => value == null || value.isEmpty ? 'Confirm your password' : null,
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
                            final success = await _controller.signUp(context);
                            setState(() {
                              _error = _controller.error;
                              _loading = false;
                            });
                            if (success) widget.onSignIn();
                          }
                        },
                        child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? ", style: TextStyle(color: AppColors.veryLightBlue)),
                        TextButton(
                          onPressed: widget.onSignIn,
                          child: const Text('Log In', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold)),
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
