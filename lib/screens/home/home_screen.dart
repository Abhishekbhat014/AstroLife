import 'package:astro_life/screens/features/birthchart_screen.dart';
import 'package:astro_life/screens/features/match_making_screen.dart';
import 'package:astro_life/screens/features/panchang_screen.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine if we should use 1 or 2 columns based on screen size
    final isTwoColumn = screenWidth > 600;
    final crossAxisCount = isTwoColumn ? 2 : 1;
    final childAspectRatio = isTwoColumn ? 1.8 : 3.0;

    // Define main feature tiles
    final List<Map<String, dynamic>> featureTiles = [
      {
        'title': 'Daily Panchang',
        'subtitle': 'Tithi, Nakshatra, Karana, Yoga',
        'icon': HugeIcons.strokeRoundedCalendar03,
        'color': colorScheme.primary,
        'destination': const PanchangScreen(),
      },
      {
        'title': 'Birth Chart (Kundali)',
        'subtitle': 'Detailed Rashi, Bhava, and Dasha Analysis',
        'icon': HugeIcons.strokeRoundedBookOpen02,
        'color': colorScheme.secondary,
        'destination': const BirthChartScreen(name: "Abhishek"),
      },
      {
        'title': 'Matchmaking (Guna Milan)',
        'subtitle': 'Check compatibility for marriage or business',
        'icon': HugeIcons.strokeRoundedManWoman,
        'color': colorScheme.tertiary,
        'destination': const MatchMakingScreen(),
      },
      {
        'title': 'Ask Astrologer (AI)',
        'subtitle': 'Instant, personalized astrological advice',
        'icon': HugeIcons.strokeRoundedArtificialIntelligence04,
        'color': colorScheme.error,
        // 'destination': const ChartScreen(), // Placeholder destination
      },
    ];

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text("AstroLife Dashboard"),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Hello User, ready for your daily insight?',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onBackground,
                ),
              ),
            ),

            // Feature Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: featureTiles.length,
              itemBuilder: (context, index) {
                final tile = featureTiles[index];
                return _buildFeatureTile(context, tile, colorScheme, textTheme);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile(
    BuildContext context,
    Map<String, dynamic> tile,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surface,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => tile['destination'] as Widget,
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tile['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: HugeIcon(
                  icon: tile['icon'],
                  color: tile['color'] as Color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tile['title'] as String,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tile['subtitle'] as String,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
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
    );
  }
}
