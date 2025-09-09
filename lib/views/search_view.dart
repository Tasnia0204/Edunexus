import 'package:flutter/material.dart';
import '../controllers/search_controller.dart';
import '../models/app_colors.dart';

class SearchView extends StatefulWidget {
  final VoidCallback onBack;
  const SearchView({super.key, required this.onBack});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final UserSearchController _controller = UserSearchController();
  final TextEditingController _searchController = TextEditingController();
  bool _byName = true;
  bool _loading = false;
  List<Map<String, dynamic>> _results = [];

  Future<void> _doSearch() async {
    setState(() { _loading = true; });
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() { _results = []; _loading = false; });
      return;
    }
    final results = await _controller.searchUsers(query: query, byName: _byName);
    setState(() {
      _results = results;
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
        title: const Text('Search User', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: _byName ? 'Search by name' : 'Search by department',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: AppColors.blue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: AppColors.darkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                  onPressed: _loading ? null : _doSearch,
                  child: const Icon(Icons.search, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _byName ? AppColors.blue : AppColors.veryLightBlue,
                    foregroundColor: _byName ? Colors.white : AppColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  onPressed: () => setState(() => _byName = true),
                  child: const Text('By Name', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_byName ? AppColors.blue : AppColors.veryLightBlue,
                    foregroundColor: !_byName ? Colors.white : AppColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  onPressed: () => setState(() => _byName = false),
                  child: const Text('By Department', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (_loading)
              const Center(child: CircularProgressIndicator()),
            if (!_loading && _results.isEmpty && _searchController.text.isNotEmpty)
              const Expanded(
                child: Center(
                  child: Text('No such user found', style: TextStyle(color: AppColors.veryLightBlue, fontSize: 18)),
                ),
              ),
            if (!_loading && _results.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: _results.length,
                  separatorBuilder: (_, __) => const Divider(color: AppColors.paleBlue),
                  itemBuilder: (context, i) {
                    final user = _results[i];
                    return ListTile(
                      title: Text(
                        user['name'] ?? '',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${user['department'] ?? ''} (${user['admittedYear'] ?? ''})',
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
