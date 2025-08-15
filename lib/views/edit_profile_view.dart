import 'package:flutter/material.dart';
import '../controllers/edit_profile_controller.dart';
import '../models/app_colors.dart';

class EditProfileView extends StatefulWidget {
  final VoidCallback onProfileUpdated;
  final VoidCallback onBack;
  const EditProfileView({super.key, required this.onProfileUpdated, required this.onBack});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final EditProfileController _controller = EditProfileController();
  bool _loading = false;
  String _error = '';
  bool _initialized = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _controller.loadUserData().then((_) {
        setState(() {
          _initialized = true;
        });
      });
    }
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
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
      ),
      body: !_initialized
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
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
                            enabled: false,
                            style: const TextStyle(color: Colors.white54),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.white38),
                              filled: true,
                              fillColor: AppColors.blue,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                            ),
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
                            controller: _controller.bioController,
                            style: const TextStyle(color: Colors.white),
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Bio',
                              labelStyle: const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: AppColors.blue,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                                  final success = await _controller.updateProfile();
                                  setState(() {
                                    _error = _controller.error;
                                    _loading = false;
                                  });
                                  if (success) widget.onProfileUpdated();
                                }
                              },
                              child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Confirm Edit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                            ),
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
