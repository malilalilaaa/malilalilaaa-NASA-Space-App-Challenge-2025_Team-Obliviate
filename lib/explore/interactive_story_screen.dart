import 'package:flutter/material.dart';
import 'sar_insight.dart'; // Make sure you have this file from the previous step

class InteractiveStoryScreen extends StatelessWidget {
  final List<SarInsight> discoveredInsights;

  const InteractiveStoryScreen({super.key, required this.discoveredInsights});

  @override
  Widget build(BuildContext context) {
    final int totalPoints = discoveredInsights.fold(
      0,
      (sum, item) => sum + item.points,
    );
    final int insightsCount = discoveredInsights.length;

    // --- KEY CHANGE: Use a Stack for the background ---
    return Stack(
      children: [
        // Layer 1: The Gradient that covers the ENTIRE screen
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/quiz.png"), // Your image path
              fit: BoxFit.cover, // This makes the image cover the entire screen
            ),
          ),
        ),

        // Layer 2: The UI, built with a TRANSPARENT Scaffold
        Scaffold(
          backgroundColor: Colors.transparent, // Makes Scaffold see-through
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 120),
                _buildStoryProgress(),
                const SizedBox(height: 16),
                _buildStatsBar(totalPoints, insightsCount),
                const SizedBox(height: 24),
                _buildNavigationButtons(),
                const SizedBox(height: 24),
                _buildArDiscoveryCard(context),
                const SizedBox(height: 24),
                _buildDiscoveriesSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoryProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Story Progress',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '0%',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.0,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar(int totalPoints, int insightsCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 24),
          const SizedBox(width: 8),
          Text(
            '$totalPoints Points',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
          const Icon(Icons.search, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Text(
            '$insightsCount Insights Found',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Previous'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white,
              disabledBackgroundColor: Colors.white.withOpacity(0.7),
              disabledForegroundColor: Colors.grey.shade400,
              elevation: 2,
              shadowColor: Colors.grey.withOpacity(0.1),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            label: const Text('Next'),
            icon: const Icon(Icons.arrow_forward),
            iconAlignment: IconAlignment.end,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF677BC8),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArDiscoveryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF7B3FE8),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.camera_alt_outlined, color: Colors.white, size: 36),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AR Discovery Mode',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Pan your camera to find hidden SAR insights',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: null,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Start AR Experience'),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'Your Discoveries',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: discoveredInsights
              .map(
                (insight) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: _DiscoveryCard(insight: insight),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _DiscoveryCard extends StatelessWidget {
  final SarInsight insight;
  const _DiscoveryCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(insight.icon, color: insight.color, size: 20),
              const SizedBox(width: 8),
              Text(
                '+${insight.points}',
                style: TextStyle(
                  color: insight.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            insight.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            insight.description,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
