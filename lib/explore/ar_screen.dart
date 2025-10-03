import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// --- STEP 1: IMPORT THE NEW FILES ---
import 'interactive_story_screen.dart';
import 'sar_insight.dart';

class ARExperienceScreen extends StatefulWidget {
  const ARExperienceScreen({super.key});

  @override
  State<ARExperienceScreen> createState() => _ARExperienceScreenState();
}

class _ARExperienceScreenState extends State<ARExperienceScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isLoading = true;
  bool _showInsights = false;

  final List<SarInsight> _discoveredInsights = [
    SarInsight.subsidence,
    SarInsight.microclimate,
  ];

  @override
  void initState() {
    super.initState();
    _initializeCameraAndStartFlow();
  }

  Future<void> _initializeCameraAndStartFlow() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(cameras[0], ResolutionPreset.high);
        await _cameraController!.initialize();
        if (mounted) {
          setState(() => _isCameraInitialized = true);
          _startLoadingSimulation();
        }
      }
    } else {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required for AR Mode.'),
          ),
        );
      }
    }
  }

  void _startLoadingSimulation() {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showInsights = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_isCameraInitialized)
            Positioned.fill(child: CameraPreview(_cameraController!))
          else
            const Center(child: CircularProgressIndicator()),
          _buildTopBar(),
          _buildInsightCards(),
          _buildExitButton(), // This method is now updated
        ],
      ),
    );
  }

  // --- STEP 3: UPDATE THE NAVIGATION IN THE EXIT BUTTON ---
  Widget _buildExitButton() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            // THE ONLY CHANGE IS HERE:
            // Instead of just popping, we replace the current screen
            // with the InteractiveStoryScreen and pass our data to it.
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => InteractiveStoryScreen(
                  discoveredInsights: _discoveredInsights,
                ),
              ),
            );
          },
          icon: const Icon(Icons.close, color: Colors.white),
          label: const Text(
            'Exit AR Mode',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.withOpacity(0.9),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AR Discovery Mode',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Pan your camera to find hidden SAR insights',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            if (_isLoading) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCards() {
    // ... (This code remains unchanged)
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _showInsights ? 1.0 : 0.0,
      child: Stack(
        children: [
          Positioned(
            top: 250,
            left: 30,
            right: 80,
            child: _InsightCard(
              rarityColor: Colors.purple.shade300,
              icon: Icons.arrow_downward,
              rarity: 'legendary',
              points: '+200',
              title: 'Subsidence Alert',
              description: 'You are sinking by 2.1 cm per year',
            ),
          ),
          Positioned(
            top: 420,
            left: 100,
            right: 20,
            child: _InsightCard(
              rarityColor: Colors.grey.shade500,
              icon: Icons.thermostat,
              rarity: 'common',
              points: '+25',
              title: 'Microclimate Zone',
              description: 'This area is 2.8°C warmer than its surroundings',
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final Color rarityColor;
  final IconData icon;
  final String rarity;
  final String points;
  final String title;
  final String description;

  const _InsightCard({
    required this.rarityColor,
    required this.icon,
    required this.rarity,
    required this.points,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: rarityColor, size: 18),
              const SizedBox(width: 8),
              Text(
                rarity,
                style: TextStyle(
                  color: rarityColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Text(
                points,
                style: TextStyle(
                  color: rarityColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
