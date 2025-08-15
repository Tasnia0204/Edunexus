import 'package:flutter/material.dart';
import '../controllers/group_controller.dart';
import '../models/app_colors.dart';

class GroupView extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final VoidCallback onCreateGroup;
  const GroupView({super.key, required this.onBack, required this.onSearch, required this.onCreateGroup});

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  final GroupController _controller = GroupController();
  bool _loading = true;
  List<Map<String, dynamic>> _groups = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final groups = await _controller.getUserGroups();
    setState(() {
      _groups = groups;
      _loading = false;
    });
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: widget.onSearch,
          ),
        ],
        title: const Text('Groups', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
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
                onPressed: widget.onCreateGroup,
                child: const Text('Create New Group', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 32),
            if (_loading)
              const Center(child: CircularProgressIndicator()),
            if (!_loading && _groups.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('No groups found', style: TextStyle(color: AppColors.veryLightBlue, fontSize: 18)),
                ),
              ),
            if (!_loading && _groups.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: _groups.length,
                  separatorBuilder: (_, __) => const Divider(color: AppColors.paleBlue),
                  itemBuilder: (context, i) {
                    final group = _groups[i];
                    return ListTile(
                      title: Text(
                        group['name'] ?? '',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        group['description'] ?? '',
                        style: const TextStyle(color: AppColors.veryLightBlue),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
