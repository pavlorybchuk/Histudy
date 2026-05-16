import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

    setState(() => _quotes = list);
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
            fontSize: 28,
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
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),

              itemCount: _quotes!.length,

              separatorBuilder: (_, __) => const SizedBox(height: 18),

              itemBuilder: (context, index) {
                return _QuoteCard(quote: _quotes![index]);
              },
            ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final _Quote quote;

  const _QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),

        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [Colors.white, Color(0xFFF8FAFC)],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Quote Icon
            Container(
              padding: EdgeInsets.all(10),

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                ),

                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B6B).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),

              child: Icon(Icons.format_quote_rounded, color: Colors.white,),
            ),

            const SizedBox(height: 20),

            Text(
              quote.quote,

              style: const TextStyle(
                fontSize: 18,
                height: 1.7,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),

            const SizedBox(height: 22),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        quote.description,
                
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
    );
  }
}
