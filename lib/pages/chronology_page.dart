import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import "package:histudy/utils.dart";

sealed class _ChronologyItem {}

class _CenturyItem extends _ChronologyItem {
  final String century;
  _CenturyItem(this.century);
}

class _EventItem extends _ChronologyItem {
  final String year;
  final String description;

  _EventItem(this.year, this.description);
}

class ChronologyPage extends StatefulWidget {
  const ChronologyPage({super.key});

  @override
  State<ChronologyPage> createState() => _ChronologyPageState();
}

class _ChronologyPageState extends State<ChronologyPage> {
  List<_ChronologyItem>? _items;
  List<String>? _centuries;

  final Map<String, int> _centuryIndex = {};

  String? _activeCentury;

  final _scrollController = ItemScrollController();
  final _positionsListener = ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    _positionsListener.itemPositions.addListener(_onScroll);
    _loadData();
  }

  @override
  void dispose() {
    _positionsListener.itemPositions.removeListener(_onScroll);
    super.dispose();
  }

  Future<void> _loadData() async {
    final raw = await rootBundle.loadString('assets/history_data.json');

    final json = jsonDecode(raw) as Map<String, dynamic>;
    final chronology = json['chronology'] as Map<String, dynamic>;

    final items = <_ChronologyItem>[];
    final centuries = <String>[];

    for (final century in chronology.keys) {
      _centuryIndex[century] = items.length;

      centuries.add(century);

      items.add(_CenturyItem(century));

      final eventsList = chronology[century] as List<dynamic>;

      for (final e in eventsList) {
        final eventMap = e as Map<String, dynamic>;

        final year = eventMap['year'] as String;
        final description = eventMap['event'] as String;

        items.add(_EventItem(year, description));
      }
    }

    setState(() {
      _items = items;
      _centuries = centuries;

      if (centuries.isNotEmpty) {
        _activeCentury = centuries.first;
      }
    });
  }

  void _onScroll() {
    if (_centuries == null) return;

    final positions = _positionsListener.itemPositions.value.toList();

    if (positions.isEmpty) return;

    final topIndex = positions
        .reduce((a, b) => a.itemLeadingEdge < b.itemLeadingEdge ? a : b)
        .index;

    String? active;

    for (final century in _centuries!) {
      if (_centuryIndex[century]! <= topIndex) {
        active = century;
      } else {
        break;
      }
    }

    if (active != null && active != _activeCentury) {
      setState(() => _activeCentury = active);
    }
  }

  void _scrollToCentury(String century) {
    final index = _centuryIndex[century];

    if (index == null) return;

    _scrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      alignment: 0,
    );

    setState(() => _activeCentury = century);
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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),

          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E293B),
          ),
        ),
        title: const Text(
          "Хронологія",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),

      body: _items == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(child: _buildList()),

                Positioned(
                  right: 10,
                  top: 0,
                  bottom: 0,
                  width: _kPanelWidth,
                  child: Center(
                    child: _AnchorPanel(
                      centuries: _centuries!,
                      activeCentury: _activeCentury,
                      onTap: _scrollToCentury,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildList() {
    return ScrollablePositionedList.builder(
      itemCount: _items!.length,
      itemScrollController: _scrollController,
      itemPositionsListener: _positionsListener,
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 24),
      itemBuilder: (context, index) {
        final item = _items![index];

        return switch (item) {
          _CenturyItem(century: final c) => _CenturySeparator(century: c),

          _EventItem(year: final y, description: final d) => _EventTile(
            year: y,
            description: d,
          ),
        };
      },
    );
  }
}

const double _kPanelWidth = 58;

class _CenturySeparator extends StatelessWidget {
  final String century;

  const _CenturySeparator({required this.century});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          const Expanded(
            child: Divider(thickness: 1.2, color: Color(0xFFD1D5DB)),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),

            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),

              gradient: const LinearGradient(
                colors: [Color(0xFF7B61FF), Color(0xFF5B46D6)],
              ),

              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7B61FF).withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),

            child: Text(
              century == "BC" ? "ДО Н. Е." : "$century століття",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const Expanded(
            child: Divider(thickness: 1.2, color: Color(0xFFD1D5DB)),
          ),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final String year;
  final String description;

  const _EventTile({required this.year, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),

      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(24),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Center(
          child: Column(
            mainAxisSize: .min,
            mainAxisAlignment: .center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),

                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B61FF), Color(0xFF927CFF)],
                  ),
                ),

                child: Text(
                  year,
                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),

              Divider(),

              Text(
                description.capitalized,

                style: const TextStyle(
                  fontSize: 15.5,
                  height: 1.5,
                  color: Color(0xFF334155),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnchorPanel extends StatelessWidget {
  final List<String> centuries;
  final String? activeCentury;
  final ValueChanged<String> onTap;

  const _AnchorPanel({
    required this.centuries,
    required this.activeCentury,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: .hardEdge,
      constraints: BoxConstraints(maxHeight: 350),
      decoration: BoxDecoration(
        color: Colors.white,
        border: BoxBorder.all(
          color: const Color.fromARGB(255, 200, 200, 200),
          strokeAlign: 1
        ),
        borderRadius: BorderRadius.circular(30),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(-2, 0),
          ),
        ],
      ),

      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: Column(
          children: centuries
              .map(
                (c) => _AnchorButton(
                  century: c,
                  isActive: c == activeCentury,
                  onTap: () => onTap(c),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _AnchorButton extends StatelessWidget {
  final String century;
  final bool isActive;
  final VoidCallback onTap;

  const _AnchorButton({
    required this.century,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),

      child: Tooltip(
        message: century == "BC" ? "ДО Н. Е." : "$century століття",

        child: Material(
          color: Colors.transparent,

          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),

              width: 42,
              height: 42,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),

                gradient: isActive
                    ? const LinearGradient(
                        colors: [Color(0xFF7B61FF), Color(0xFF5B46D6)],
                      )
                    : null,

                color: isActive ? null : const Color(0xFFF1F5F9),

                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: const Color(0xFF7B61FF).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),

              child: Center(
                child: Text(
                  century == "BC" ? "ДО\nН. Е." : century,
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFF475569),

                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
