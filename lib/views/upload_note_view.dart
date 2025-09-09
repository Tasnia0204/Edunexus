import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadNoteView extends StatefulWidget {
  const UploadNoteView({super.key});

  @override
  State<UploadNoteView> createState() => _UploadNoteViewState();
}

class _UploadNoteViewState extends State<UploadNoteView> {
  final _formKey = GlobalKey<FormState>();
  final _noteNameController = TextEditingController();
  final _courseNameController = TextEditingController();
  final _facultyNameController = TextEditingController();
  final _driveLinkController = TextEditingController();
  bool _loading = false;
  String _error = '';

  @override
  void dispose() {
    _noteNameController.dispose();
    _courseNameController.dispose();
    _facultyNameController.dispose();
    _driveLinkController.dispose();
    super.dispose();
  }

  Future<void> _uploadNote() async {
    setState(() { _loading = true; _error = ''; });
    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('notes').add({
        'noteName': _noteNameController.text.trim(),
        'courseName': _courseNameController.text.trim(),
        'facultyName': _facultyNameController.text.trim(),
        'driveLink': _driveLinkController.text.trim(),
        'authorId': user?.uid,
        'authorName': user?.displayName ?? user?.email ?? 'Unknown',
        'timestamp': FieldValue.serverTimestamp(),
      });
      Navigator.pop(context);
    } catch (e) {
      setState(() { _error = 'Failed to upload note.'; });
    }
    setState(() { _loading = false; });
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Upload Note', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _noteNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Note Name',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: AppColors.blue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Enter note name' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _courseNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Course Name',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: AppColors.blue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Enter course name' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _facultyNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Faculty Name',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: AppColors.blue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Enter faculty name' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _driveLinkController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Google Drive Link',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: AppColors.blue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Enter Google Drive link' : null,
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
                  onPressed: _loading ? null : () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _uploadNote();
                    }
                  },
                  child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Upload', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
