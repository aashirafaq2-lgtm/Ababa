import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class SmartSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  const SmartSearchBar({super.key, required this.onSearch});

  @override
  State<SmartSearchBar> createState() => _SmartSearchBarState();
}

class _SmartSearchBarState extends State<SmartSearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _showSuggestions = false;
  List<String> _suggestions = [];

  // Simulated Elasticsearch suggest API call
  Future<void> _fetchSuggestions(String query) async {
    if (query.length < 2) {
      setState(() { _suggestions = []; _showSuggestions = false; });
      return;
    }
    // Real integration: GET /v1/search/suggest?q=query
    // For now seed with realistic B2B suggestions
    final demoSuggestions = [
      '$query machinery', '$query supplier', '$query wholesale',
      '$query factory price', '$query bulk order'
    ];
    setState(() {
      _suggestions = demoSuggestions;
      _showSuggestions = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: _fetchSuggestions,
            onSubmitted: (q) {
              setState(() => _showSuggestions = false);
              widget.onSearch(q);
            },
            decoration: InputDecoration(
              hintText: 'Search 1688 factories & products...',
              hintStyle: TextStyle(color: AhmedBabaTokens.textSecondary, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: AhmedBabaTokens.primary),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: () {
                      _controller.clear();
                      setState(() => _showSuggestions = false);
                    }) 
                  : Icon(Icons.camera_alt_outlined, color: AhmedBabaTokens.textSecondary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        if (_showSuggestions && _suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16)],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _suggestions.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: AhmedBabaTokens.border),
              itemBuilder: (ctx, i) => ListTile(
                leading: const Icon(Icons.search, color: Colors.grey, size: 18),
                title: Text(_suggestions[i], style: const TextStyle(fontSize: 14)),
                onTap: () {
                  _controller.text = _suggestions[i];
                  setState(() => _showSuggestions = false);
                  widget.onSearch(_suggestions[i]);
                },
              ),
            ),
          ),
      ],
    );
  }
}
