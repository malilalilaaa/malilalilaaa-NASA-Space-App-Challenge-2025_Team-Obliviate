import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'location_map_screen.dart';

void main() {
  runApp(const MaterialApp(home: ExploreScreen1()));
}

// =========================================================================
// WIDGET: The pop-up form for uploading a dataset (Unchanged)
// =========================================================================
class UploadDatasetForm extends StatefulWidget {
  const UploadDatasetForm({super.key});

  @override
  State<UploadDatasetForm> createState() => _UploadDatasetFormState();
}

class _UploadDatasetFormState extends State<UploadDatasetForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedSatellite = 'Sentinel-1';
  String? _selectedCategory = 'Research';
  final List<String> _satelliteOptions = [
    'Sentinel-1',
    'TerraSAR-X',
    'COSMO-SkyMed',
    'RADARSAT-2',
  ];
  final List<String> _categoryOptions = [
    'Research',
    'Agriculture',
    'Disaster Monitoring',
    'Urban Planning',
    'Forestry',
  ];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      insetPadding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Upload SAR Dataset',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildTextFieldLabel('Dataset Title'),
                TextFormField(
                  decoration: _inputDecoration(
                    "e.g., Urban Monitoring - New York 2024",
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextFieldLabel('Description'),
                TextFormField(
                  maxLines: 3,
                  decoration: _inputDecoration(
                    "Describe your dataset and research objectives...",
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextFieldLabel('Location'),
                          TextFormField(
                            decoration: _inputDecoration("City, Country"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextFieldLabel('Location'),
                          DropdownButtonFormField<String>(
                            value: _selectedSatellite,
                            items: _satelliteOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedSatellite = newValue;
                              });
                            },
                            decoration: _inputDecoration(""),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextFieldLabel('Category'),
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            items: _categoryOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategory = newValue;
                              });
                            },
                            decoration: _inputDecoration(""),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextFieldLabel('Coverage Area'),
                          TextFormField(
                            decoration: _inputDecoration("e.g., 500 km²"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Community Guidelines',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFF6F7D9B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file_outlined, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Upload Dataset',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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

  Widget _buildTextFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF6F8ABB)),
      ),
    );
  }
}

// =========================================================================
// Main Screen - Integrated with the new views
// =========================================================================

class ExploreScreen1 extends StatefulWidget {
  const ExploreScreen1({super.key});

  @override
  State<ExploreScreen1> createState() => _ExploreScreen1State();
}

class _ExploreScreen1State extends State<ExploreScreen1> {
  int _bottomNavIndex = 4;
  int _selectedSegment = 0;

  void _showUploadDatasetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => const UploadDatasetForm(),
    );
  }

  Future<void> _handleSelectLocation() async {
    // ... your existing location logic remains unchanged ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/quiz.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        const SizedBox(height: 50),
                        _buildSegmentedControl(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _buildSelectedScreen(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE7EAF3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildSegmentItem('SAR Data', 0),
          _buildSegmentItem('AI Explainer', 1),
          _buildSegmentItem('Impact Mode', 2),
        ],
      ),
    );
  }

  Widget _buildSegmentItem(String text, int index) {
    bool isSelected = _selectedSegment == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSegment = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6F8ABB) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedScreen() {
    final currentKey = ValueKey<int>(_selectedSegment);
    switch (_selectedSegment) {
      case 0:
        return Padding(
          key: currentKey,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SarImageProcessor(),
              const SizedBox(height: 24),
              InfoCard(
                icon: Icons.group_work_rounded,
                title: 'Research Community',
                description:
                    'Share your SAR datasets with researchers worldwide',
                buttonText: 'Upload & Share Dataset',
                buttonIcon: Icons.upload_rounded,
                onButtonPressed: _showUploadDatasetDialog,
              ),
              const SizedBox(height: 16),
              InfoCard(
                icon: Icons.location_on_rounded,
                title: 'Select Your Location',
                description: 'Choose a city to analyze Sentinel-1 SAR imagery',
                buttonText: 'Select City',
                buttonIcon: Icons.my_location,
                hasGlobeIcon: true,
                onButtonPressed: _handleSelectLocation,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      case 1:
        return AiExplainerView(key: currentKey);
      case 2:
        return ImpactModeView(key: currentKey);
      default:
        return Center(key: currentKey, child: const Text("Unknown"));
    }
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    const Color navBarBackgroundColor = Color(0xFFDDEBFF);
    const Color navBarItemColor = Color(0xFF2A4D8E);
    const double iconSize = 28.0;
    return BottomNavigationBar(
      currentIndex: _bottomNavIndex,
      onTap: (index) {
        setState(() {
          _bottomNavIndex = index;
        });
      },
      backgroundColor: navBarBackgroundColor,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedItemColor: navBarItemColor,
      unselectedItemColor: navBarItemColor,
      selectedFontSize: 12.0,
      unselectedFontSize: 12.0,
      items: const [
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Image(
              image: AssetImage('assets/Home.png'),
              height: iconSize,
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Image(
              image: AssetImage('assets/Quizlet.png'),
              height: iconSize,
            ),
          ),
          label: 'Quiz',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Image(
              image: AssetImage('assets/Teaching.png'),
              height: iconSize,
            ),
          ),
          label: 'Learn',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Image(
              image: AssetImage('assets/Shield.png'),
              height: iconSize,
            ),
          ),
          label: 'Badges',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Image(
              image: AssetImage('assets/Compass.png'),
              height: iconSize,
            ),
          ),
          label: 'Explore',
        ),
      ],
    );
  }
}

// --- InfoCard WIDGET (Unchanged) ---
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final IconData? buttonIcon;
  final bool hasGlobeIcon;
  final VoidCallback onButtonPressed;
  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onButtonPressed,
    this.buttonIcon,
    this.hasGlobeIcon = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xAAF7EAEF), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF007BFF).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: const Color(0xFF0056b3)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (hasGlobeIcon)
                Icon(Icons.language, color: Colors.grey.shade600),
            ],
          ),
          const SizedBox(height: 8),
          Text(description, style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onButtonPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: const Color(0xFF6F8ABB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (buttonIcon != null) ...[
                  Icon(buttonIcon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- SAR Image Processor WIDGETS (Unchanged) ---
class SarImageProcessor extends StatefulWidget {
  const SarImageProcessor({super.key});
  @override
  State<SarImageProcessor> createState() => _SarImageProcessorState();
}

class _SarImageProcessorState extends State<SarImageProcessor> {
  Uint8List? _inputImageBytes;
  String? _outputImagePath;
  bool _isProcessing = false;
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _inputImageBytes = bytes;
        _isProcessing = true;
        _outputImagePath = null;
      });
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _outputImagePath = 'assets/after.png';
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FE),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'SAR Image AI Converter',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ImageContainer(
                  label: 'SAR Input',
                  onTap: _pickImage,
                  child: _inputImageBytes == null
                      ? const Icon(
                          Icons.upload_file_rounded,
                          size: 40,
                          color: Colors.grey,
                        )
                      : Image.memory(_inputImageBytes!, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: _isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      )
                    : Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.purple.shade300,
                        size: 28,
                      ),
              ),
              Expanded(
                child: _ImageContainer(
                  label: 'Processed Output',
                  child: _outputImagePath == null
                      ? Icon(
                          Icons.image_search_rounded,
                          size: 40,
                          color: Colors.grey.shade400,
                        )
                      : Image.asset(_outputImagePath!, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImageContainer extends StatelessWidget {
  final String label;
  final Widget child;
  final VoidCallback? onTap;
  const _ImageContainer({required this.label, required this.child, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: child,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// WIDGET: AI Explainer View (Added to this file)
// =========================================================================

class AiExplainerView extends StatelessWidget {
  const AiExplainerView({super.key});
  static const String amazonDeforestationPath = 'assets/i2.png';
  static const String bangladeshFloodPath = 'assets/i1.png';

  void _showExampleImagesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Example SAR Images',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _DetailedExampleCard(
                  imagePath: AiExplainerView.bangladeshFloodPath,
                  title: 'Bangladesh Flood Monitoring',
                  description:
                      'Sentinel-1 SAR imagery showing flood extent during monsoon season',
                  location: 'Dhaka, Bangladesh',
                  date: '2023-07-15',
                ),
                const SizedBox(height: 16),
                const _DetailedExampleCard(
                  imagePath: AiExplainerView.amazonDeforestationPath,
                  title: 'Amazon Deforestation Tracking',
                  description:
                      'Multi-temporal SAR analysis highlights areas of recent deforestation',
                  location: 'Rondônia, Brazil',
                  date: '2023-05-20',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.cloud_upload_outlined, color: Colors.blueAccent),
                    SizedBox(width: 8),
                    Text(
                      'Upload or Explore SAR Images',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 40,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Drag & drop your SAR image here\nor click to browse files',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('or', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _showExampleImagesDialog(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFF8A9BB8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Explore Example Images',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Example SAR Images',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const _ExampleSarCard(
            imagePath: AiExplainerView.amazonDeforestationPath,
            title: 'Amazon Deforestation Tracking',
            location: 'Rondônia, Brazil',
            tag: 'VH',
            duration: '15m',
          ),
          const SizedBox(height: 16),
          const _ExampleSarCard(
            imagePath: AiExplainerView.bangladeshFloodPath,
            title: 'Bangladesh Flood Monitoring',
            location: 'Dhaka Metropolitan Area',
            tag: 'VV',
            duration: '10m',
          ),
        ],
      ),
    );
  }
}

// --- FIX IS HERE: Changed Image.network to Image.asset ---
class _ExampleSarCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String location;
  final String tag;
  final String duration;
  const _ExampleSarCard({
    required this.imagePath,
    required this.title,
    required this.location,
    required this.tag,
    required this.duration,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              // <-- CORRECTED
              imagePath,
              width: 100,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      duration,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- FIX IS HERE: Changed Image.network to Image.asset ---
class _DetailedExampleCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String location;
  final String date;
  const _DetailedExampleCard({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              // <-- CORRECTED
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 120,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                location,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              Text(
                date,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// WIDGET: Impact Mode View (Added to this file)
// =========================================================================

class ImpactModeView extends StatelessWidget {
  const ImpactModeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.explore_outlined,
                    size: 40,
                    color: Colors.pink.shade400,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Impact Mode',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'Advanced analysis tools for real-world impact assessment',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Coming Soon: Disaster impact modeling, economic loss estimation, and population exposure analysis',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
