import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import "package:histudy/utils.dart";

class _Quote {
  final String quote;
  final String description;

  const _Quote({required this.quote, required this.description});

  factory _Quote.fromJson(Map<String, dynamic> json) => _Quote(
    quote: json['quote'] as String,
    description: json['description'] as String,
  );
}

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  List<_Quote>? _quotes;
  int? _bookmarkedIndex;
  final _scrollController = ItemScrollController();
  final _positionsListener = ItemPositionsListener.create();

  static const _kPrefsKey = 'bookmarked_quote_index';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final raw = await rootBundle.loadString('assets/history_data.json');

    final json = jsonDecode(raw) as Map<String, dynamic>;

    final list = (json['quotes'] as List<dynamic>)
        .map((e) => _Quote.fromJson(e as Map<String, dynamic>))
        .toList();

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_kPrefsKey);

    final bookmarked = (saved != null && saved < list.length) ? saved : null;

    setState(() {
      _quotes = list;
      _bookmarkedIndex = bookmarked;
    });

    if (bookmarked != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.isAttached) {
          _scrollController.scrollTo(
            index: bookmarked,
            duration: const Duration(milliseconds: 1),
            alignment: 0.08,
          );
        }
      });
    }
  }

  Future<void> _toggleBookmark(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final isAlreadyBookmarked = _bookmarkedIndex == index;

    setState(() {
      _bookmarkedIndex = isAlreadyBookmarked ? null : index;
    });

    if (isAlreadyBookmarked) {
      await prefs.remove(_kPrefsKey);
    } else {
      await prefs.setInt(_kPrefsKey, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        centerTitle: true,

        title: const Text(
          "Цитати",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E293B),
          ),
        ),
      ),

      body: _quotes == null
          ? const Center(child: CircularProgressIndicator())
          : _quotes!.isEmpty
              ? const Center(
                  child: Text(
                    "Цитати відсутні",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                )
              : ScrollablePositionedList.builder(
                  itemScrollController: _scrollController,
                  itemPositionsListener: _positionsListener,
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
                  itemCount: _quotes!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < _quotes!.length - 1 ? 18 : 0,
                      ),
                      child: _QuoteCard(
                        quote: _quotes![index],
                        isBookmarked: _bookmarkedIndex == index,
                        onTap: () => _toggleBookmark(index),
                      ),
                    );
                  },
                ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final _Quote quote;
  final bool isBookmarked;
  final VoidCallback onTap;

  const _QuoteCard({
    super.key,
    required this.quote,
    required this.isBookmarked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),

          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFF8FAFC)],
          ),

          boxShadow: [
            BoxShadow(
              color: isBookmarked
                  ? const Color(0xFFFF6B6B).withOpacity(0.18)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isBookmarked ? 24 : 16,
              offset: const Offset(0, 8),
            ),
          ],

          border: isBookmarked
              ? Border.all(
                  color: const Color(0xFFFF6B6B).withOpacity(0.4),
                  width: 1.5,
                )
              : null,
        ),

        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Bookmark badge — only shown when bookmarked.
              if (isBookmarked) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6B6B).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bookmark_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Закладка",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],

              Text(
                quote.quote,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.7,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),

              const SizedBox(height: 22),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFF8FAFC),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),

                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Text(
                          quote.description.capitalized,
                          style: const TextStyle(
                            fontSize: 14.5,
                            height: 1.6,
                            color: Color(0xFF475569),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}