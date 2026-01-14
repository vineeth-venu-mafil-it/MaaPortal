import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controller/home_controller.dart';
import '../model/task_model.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Top Yellow Header
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.11,
                  color: const Color(0xFFFFD013),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'MANAPPURAM APPLICATION PORTAL',
                          style: GoogleFonts.readexPro(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                // Main Content Area
                Expanded(
                  child: Row(
                    children: [
                      // Left: Apps Grid with Search & Tabs (75%)
                      Expanded(
                        flex: 3,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final isMobile = constraints.maxWidth < 600;
                            final isTablet = constraints.maxWidth >= 600 &&
                                constraints.maxWidth < 1200;
                            final isDesktop = constraints.maxWidth >= 1200;

                            return Consumer<HomeController>(
                              builder: (context, provider, _) {
                                return Column(
                                  children: [
                                    // Search Bar Section
                                    Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'MANAPPURAM APPLICATION PORTAL',
                                              style: GoogleFonts.readexPro(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 250,
                                            child: TextField(
                                              controller: _searchController,
                                              onChanged:
                                                  provider.updateSearchQuery,
                                              style: GoogleFonts.readexPro(
                                                  fontSize: 14),
                                              decoration: InputDecoration(
                                                hintText: 'Search apps...',
                                                hintStyle:
                                                    GoogleFonts.readexPro(
                                                  color: Colors.grey,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                                prefixIcon: const Icon(
                                                    Icons.search,
                                                    color: Colors.grey),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: Colors.grey),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: Colors.grey),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFFB53F3F),
                                                      width: 2),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Tabs + Grid
                                    Expanded(
                                      child: DefaultTabController(
                                        length: 2,
                                        child: Column(
                                          children: [
                                            Material(
                                              child: TabBar(
                                                onTap: (index) {
                                                  provider.currentTabIndex =
                                                      index;
                                                },
                                                labelColor:
                                                    const Color(0xFFB53F3F),
                                                unselectedLabelColor:
                                                    Colors.grey[600],
                                                labelStyle:
                                                    GoogleFonts.readexPro(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                unselectedLabelStyle:
                                                    GoogleFonts.readexPro(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                indicatorColor:
                                                    const Color(0xFF911A1A),
                                                tabs: const [
                                                  Tab(text: "Primary"),
                                                  Tab(text: "General"),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: provider.isLoading
                                                    ? _buildShimmerGrid(
                                                        isDesktop, isMobile)
                                                    : provider
                                                            .currentData.isEmpty
                                                        ? Center(
                                                            child: Text(
                                                              "No items found",
                                                              style: GoogleFonts
                                                                  .readexPro(
                                                                color: Colors
                                                                    .grey[600],
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          )
                                                        : _buildTaskGrid(
                                                            provider
                                                                .currentData,
                                                            provider,
                                                            isDesktop,
                                                            isMobile,
                                                            isTablet,
                                                          ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),

                      // Vertical Divider
                      Container(
                        width: 1,
                        color: Colors.grey[300],
                      ),

                      // Right Sidebar (25%)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Container(
                          color: Colors.grey[50],
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quick Links',
                                style: GoogleFonts.readexPro(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Add your quick links here
                              const Spacer(),
                              Text(
                                '© 2026 Manappuram Finance Ltd.',
                                style: GoogleFonts.readexPro(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskGrid(
    List<TaskDetails> tasks,
    HomeController provider,
    bool isDesktop,
    bool isMobile,
    bool isTablet,
  ) {
    return isMobile
        ? ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return _buildTaskCard(context, tasks[index], provider, index);
            },
          )
        : GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 3 : 3,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 3.4,
            ),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return _buildTaskCard(context, tasks[index], provider, index);
            },
          );
  }

  Widget _buildTaskCard(BuildContext context, TaskDetails task,
      HomeController provider, int index) {
    return MouseRegion(
      onEnter: (_) => provider.setHoveredIndex(index),
      onExit: (_) => provider.clearHover(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Transform.scale(
          scale: provider.hoveredIndex == index ? 1.04 : 1.0,
          child: Material(
            elevation: 1.5,
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey, width: 0.6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
                onTap: () {
                  // Handle tap - replace with your navigation logic
                  // Example: Navigator.push(...);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.orange, Colors.yellow],
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: CachedNetworkImage(
                              imageUrl: task.reqType ?? '',
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(
                                  Icons.image,
                                  color: Colors.black26),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              task.content ?? '',
                              style: GoogleFonts.readexPro(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'This is the dot net web application',
                              style: GoogleFonts.readexPro(
                                fontSize: 9.0,
                                color: const Color(0xFF911A1A),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
        ),
      ),
    );
  }

  Widget _buildShimmerGrid(bool isDesktop, bool isMobile) {
    final crossAxisCount = isDesktop
        ? 6
        : isMobile
            ? 2
            : 4;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 12,
      itemBuilder: (context, index) => const ShimmerCard(),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 12),
            Container(width: 80, height: 14, color: Colors.white),
            const SizedBox(height: 8),
            Container(width: 60, height: 10, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
