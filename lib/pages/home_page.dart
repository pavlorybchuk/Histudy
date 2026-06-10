import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chronology_page.dart';
import 'quotes_page.dart';
import 'terminology_page.dart';
import 'visual_elms_page.dart';
import 'dart:io';

final List<List<dynamic>> pages = [
  [
    const ChronologyPage(),
    "Хронологія",
    "assets/chronology_img.png",
    const Color(0xFF7B61FF),
  ],
  [
    const QuotesPage(),
    "Цитати",
    "assets/quotes_img.png",
    const Color(0xFFFF6B6B),
  ],
  [
    const TerminologyPage(),
    "Термінологія",
    "assets/terminology_img.png",
    const Color(0xFF00B894),
  ],
  [
    const VisualElmsPage(),
    "Візуальні елементи",
    "assets/visual_img.png",
    const Color(0xFFFFA502),
  ],
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Головна",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Оберіть розділ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              sliver: SliverList.separated(
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return PageCard(
                    page: page[0],
                    title: page[1],
                    imageURL: page[2],
                    accentColor: page[3],
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

class PageCard extends StatelessWidget {
  const PageCard({
    super.key,
    required this.page,
    required this.title,
    required this.imageURL,
    required this.accentColor,
  });

  final String title;
  final String imageURL;
  final Widget page;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: () {
              Navigator.push(
                context,
                !Platform.isIOS
                    ? PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (_, animation, __) =>
                            FadeTransition(opacity: animation, child: page),
                      )
                    : CupertinoPageRoute(builder: (context) => page),
              );
            },
            child: SizedBox(
              height: 170,
              child: Stack(
                children: [
                  Image.asset(
                    imageURL,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          accentColor.withValues(alpha: 0.85),
                          Colors.black.withValues(alpha: 0.55),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            "Розділ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  height: 1.1,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
