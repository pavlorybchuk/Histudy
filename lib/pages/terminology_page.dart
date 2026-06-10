import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:histudy/utils.dart";

class _Term {
  final String term;
  final String description;

  const _Term({
    required this.term,
    required this.description,
  });

  factory _Term.fromJson(Map<String, dynamic> json) => _Term(
        term: json['term'] as String,
        description: json['description'] as String,
      );
}

class TerminologyPage extends StatefulWidget {
  const TerminologyPage({super.key});

  @override
  State<TerminologyPage> createState() => _TerminologyPageState();
}

class _TerminologyPageState extends State<TerminologyPage> {
  List<_Term>? _terms;
  List<_Term>? _filtered;

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _loadData();

    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  Future<void> _loadData() async {
    final raw = await rootBundle.loadString(
      'assets/history_data.json',
    );

    final json = jsonDecode(raw) as Map<String, dynamic>;

    final list = (json['terminology'] as List<dynamic>)
        .map(
          (e) => _Term.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();

    setState(() {
      _terms = list;
      _filtered = list;
    });
  }

  void _onSearch() {
    final q = _searchController.text.trim().toLowerCase();

    setState(() {
      _filtered = q.isEmpty
          ? _terms
          : _terms
              ?.where(
                (t) =>
                    t.term.toLowerCase().contains(q) ||
                    t.description.toLowerCase().contains(q),
              )
              .toList();
    });
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
          "Термінологія",
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

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(90),

          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),

            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Colors.white,

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),

              child: TextField(
                controller: _searchController,

                decoration: InputDecoration(
                  hintText: "Пошук терміну...",
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                  ),

                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF00B894),
                  ),

                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                          },

                          icon: const Icon(
                            Icons.close_rounded,
                            color: Color(0xFF64748B),
                          ),
                        )
                      : null,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      body: _terms == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _filtered!.isEmpty
              ? const Center(
                  child: Text(
                    "Нічого не знайдено",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),

                  itemCount: _filtered!.length,

                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),

                      child: _TermTile(
                        term: _filtered![index],
                      ),
                    );
                  },
                ),
    );
  }
}

class _TermTile extends StatefulWidget {
  final _Term term;

  const _TermTile({
    required this.term,
  });

  @override
  State<_TermTile> createState() => _TermTileState();
}

class _TermTileState extends State<_TermTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  late final AnimationController _ctrl;
  late final Animation<double> _expandAnim;
  late final Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _expandAnim = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeInOutCubic,
    );

    _rotateAnim = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(_expandAnim);
  }

  @override
  void dispose() {
    _ctrl.dispose();

    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);

    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            Colors.white,
            Color(0xFFF8FAFC),
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: _toggle,

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.term.term,

                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),

                    RotationTransition(
                      turns: _rotateAnim,

                      child: Container(
                        padding: const EdgeInsets.all(8),

                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: const Icon(
                          Icons.expand_more_rounded,
                          color: Color(0xFF00B894),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),

                /// Expanded Content
                SizeTransition(
                  sizeFactor: _expandAnim,
                  axisAlignment: -1,

                  child: FadeTransition(
                    opacity: _expandAnim,

                    child: Column(
                      children: [
                        const SizedBox(height: 18),

                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.all(18),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),

                            color: const Color(0xFFF8FAFC),

                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                            ),
                          ),

                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 5,
                            
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                            
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                            
                                      colors: [
                                        Color(0xFF00B894),
                                        Color(0xFF00CEC9),
                                      ],
                                    ),
                                  ),
                                ),
                            
                                const SizedBox(width: 14),
                            
                                Expanded(
                                  child: Text(
                                    widget.term.description.capitalized,
                            
                                    style: const TextStyle(
                                      fontSize: 12,
                                      height: 1.7,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}