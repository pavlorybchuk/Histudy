import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import "package:histudy/utils.dart";

class _VisualItem {
  final String path;
  final String description;

  const _VisualItem({required this.path, required this.description});

  factory _VisualItem.fromJson(Map<String, dynamic> json) => _VisualItem(
    path: json['path'] as String,
    description: json['description'] as String,
  );
}

sealed class _ListItem {}

class _CenturyHeader extends _ListItem {
  final String century;

  _CenturyHeader(this.century);
}

class _ImageItem extends _ListItem {
  final _VisualItem item;

  _ImageItem(this.item);
}

class VisualElmsPage extends StatefulWidget {
  const VisualElmsPage({super.key});

  @override
  State<VisualElmsPage> createState() => _VisualElmsPageState();
}

class _VisualElmsPageState extends State<VisualElmsPage> {
  List<_ListItem>? _items;
  List<String>? _centuries;

  String? _activeCentury;

  final Map<String, int> _centuryIndex = {};

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

    final sections = json['visual_elements'] as Map<String, dynamic>;

    final items = <_ListItem>[];
    final centuries = <String>[];

    for (final century in sections.keys) {
      _centuryIndex[century] = items.length;

      centuries.add(century);

      items.add(_CenturyHeader(century));

      final images = (sections[century] as List<dynamic>).map(
        (e) => _VisualItem.fromJson(e as Map<String, dynamic>),
      );

      for (final img in images) {
        items.add(_ImageItem(img));
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

        title: const Text(
          "Візуальні елементи",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 26,
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

      padding: const EdgeInsets.fromLTRB(16, 8, 8, 30),

      itemBuilder: (context, index) {
        final item = _items![index];

        return switch (item) {
          _CenturyHeader(century: final c) => _CenturySeparator(century: c),

          _ImageItem(item: final v) => _VisualCard(item: v),
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
                colors: [Color(0xFFFFA502), Color.fromARGB(255, 255, 179, 39)],
              ),

              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFA502).withOpacity(0.28),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),

            child: Text(
              century == "BC"
                  ? "ДО Н. Е."
                  : century == "PERS"
                  ? "Персоналії"
                  : "$century століття",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                fontSize: 14,
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

class _VisualCard extends StatelessWidget {
  final _VisualItem item;

  const _VisualCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(28),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _openFullscreen(context),

              child: Hero(
                tag: item.path,

                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),

                  child: Stack(
                    children: [
                      Image.asset(
                        item.path,
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.cover,

                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 240,
                            color: const Color(0xFFE2E8F0),

                            child: const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),

                      Positioned(
                        top: 14,
                        right: 14,

                        child: Container(
                          padding: const EdgeInsets.all(10),

                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.open_in_full_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),

              child: Text(
                item.description.capitalized,
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
    );
  }

  void _openFullscreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,

        transitionDuration: const Duration(milliseconds: 300),

        pageBuilder: (_, animation, __) {
          return FadeTransition(
            opacity: animation,
            child: _FullscreenImagePage(item: item),
          );
        },
      ),
    );
  }
}

class _FullscreenImagePage extends StatelessWidget {
  final _VisualItem item;

  const _FullscreenImagePage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 5,

              child: Hero(
                tag: item.path,

                child: Image.asset(
                  item.path,
                  fit: BoxFit.contain,

                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.broken_image_outlined,
                      size: 70,
                      color: Colors.white38,
                    );
                  },
                ),
              ),
            ),
          ),

          Positioned(
            top: 50,
            left: 16,

            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),

                child: IconButton(
                  onPressed: () => Navigator.pop(context),

                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,

            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 34),

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,

                  colors: [Colors.transparent, Colors.black.withOpacity(0.95)],
                ),
              ),

              child: Text(
                item.description,
                textAlign: TextAlign.center,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.7,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
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
          strokeAlign: 1,
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
        message: century == "BC"
            ? "ДО Н. Е."
            : century == "PERS"
            ? "Персоналії"
            : "$century століття",

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
                        colors: [Color(0xFFFFA502), Color.fromARGB(255, 255, 179, 39)],
                      )
                    : null,

                color: isActive ? null : const Color(0xFFF1F5F9),

                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: const Color(0xFFFFA502).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),

              child: Center(
                child: century != "PERS"
                    ? Text(
                        century == "BC" ? "ДО\nН. Е." : century,
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : const Color(0xFF475569),

                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: isActive
                            ? Colors.white
                            : const Color(0xFF475569),
                        size: 20,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
