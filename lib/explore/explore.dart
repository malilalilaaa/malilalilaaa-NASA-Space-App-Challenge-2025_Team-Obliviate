import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'location_map_screen.dart';
// Note: You might not have the 'ar_screen.dart' file, but it's okay for this implementation.
// import 'ar_screen.dart';

void main() {
  runApp(const MaterialApp(home: ExploreScreen()));
}

// =========================================================================
// NEW WIDGET: The pop-up form for uploading a dataset
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
    // Using Dialog for a more centered pop-up effect as seen in the image
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
                          _buildTextFieldLabel(
                            'Location',
                          ), // Label in image is the same
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
                    // TODO: Implement dataset upload logic
                    Navigator.of(
                      context,
                    ).pop(); // Close dialog on submit for now
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(
                      0xFF6F7D9B,
                    ), // Darker shade from image
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload_file_outlined,
                        color: Colors.white,
                      ), // Using a different upload icon
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
// Main Screen - Code is mostly the same, with one important change
// =========================================================================

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _bottomNavIndex = 4; // Default to 'Explore'
  int _selectedSegment = 0; // For SAR Data, AI Explainer, Impact Mode

  // --- NEW FUNCTION TO SHOW THE DIALOG ---
  void _showUploadDatasetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const UploadDatasetForm();
      },
    );
  }

  // --- LOCATION LOGIC MOVED HERE ---
  Future<void> _handleSelectLocation() async {
    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Detecting location..."),
              ],
            ),
          ),
        );
      },
    );

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      String cityName = "Unknown Location";
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        cityName =
            "${placemark.locality ?? ''}, ${placemark.administrativeArea ?? ''}";
      }

      if (mounted) {
        Navigator.of(context).pop(); // Close the loading dialog
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                LocationMapScreen(position: position, cityName: cityName),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close the loading dialog
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/quiz.png"), // Your image path
                fit: BoxFit
                    .cover, // This makes the image cover the entire screen
              ),
            ),
          ),
          // Using SafeArea to avoid top system UI (like time, battery icon)
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    const SizedBox(height: 20),

                    const SizedBox(height: 16),
                    _buildSegmentedControl(),
                    const SizedBox(height: 24),
                    const SarImageProcessor(),
                    const SizedBox(height: 24),
                    InfoCard(
                      icon: Icons.group_work_rounded,
                      title: 'Research Community',
                      description:
                          'Share your SAR datasets with researchers worldwide',
                      buttonText: 'Upload & Share Dataset',
                      buttonIcon: Icons.upload_rounded,
                      // --- THIS IS THE IMPORTANT CHANGE ---
                      // Changed from showing a SnackBar to showing our dialog
                      onButtonPressed: _showUploadDatasetDialog,
                    ),
                    const SizedBox(height: 16),
                    InfoCard(
                      icon: Icons.location_on_rounded,
                      title: 'Select Your Location',
                      description:
                          'Choose a city to analyze Sentinel-1 SAR imagery',
                      buttonText: 'Select City',
                      buttonIcon:
                          Icons.my_location, // Updated icon to match logic
                      hasGlobeIcon: true,
                      onButtonPressed:
                          _handleSelectLocation, // --- CONNECTED THE ACTION HERE ---
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
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
    switch (_selectedSegment) {
      case 0:
        return Column(
          children: [
            const SarImageProcessor(),
            const SizedBox(height: 24),
            InfoCard(
              icon: Icons.group_work_rounded,
              title: 'Research Community',
              description: 'Share your SAR datasets with researchers worldwide',
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
          ],
        );
      // case 1:
      //   return const AiExplainerView();
      // case 2:
      //   return const ImpactModeView();
      default:
        return const Center(child: Text("Unknown"));
    }
  }

  // --- REPLACE your old _buildBottomNavigationBar function with this one ---

  BottomNavigationBar _buildBottomNavigationBar() {
    // Define colors based on the image for easy customization
    const Color navBarBackgroundColor = Color(0xFFDDEBFF);
    const Color navBarItemColor = Color(0xFF2A4D8E);
    const double iconSize = 28.0; // Define a consistent size for your icons

    return BottomNavigationBar(
      currentIndex: _bottomNavIndex,
      onTap: (index) {
        setState(() {
          _bottomNavIndex = index;
        });
      },

      // --- Style Changes to match your image ---
      backgroundColor: navBarBackgroundColor, // Light blue background
      type: BottomNavigationBarType
          .fixed, // Ensures all items are visible and labels don't hide
      elevation: 0, // Removes the default shadow for a flat look
      // Set both selected and unselected colors to be the same dark blue
      selectedItemColor: navBarItemColor,
      unselectedItemColor: navBarItemColor,

      // Consistent font size whether selected or not
      selectedFontSize: 12.0,
      unselectedFontSize: 12.0,

      // --- Item Definitions using Image.asset ---
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(
              bottom: 4.0,
            ), // Add a little space between icon and text
            child: Image.asset('assets/Home.png', height: iconSize),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Image.asset('assets/Quizlet.png', height: iconSize),
          ),
          label: 'Quiz',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Image.asset('assets/Teaching.png', height: iconSize),
          ),
          label: 'Learn',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Image.asset('assets/Shield.png', height: iconSize),
          ),
          label: 'Badges',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Image.asset('assets/Compass.png', height: iconSize),
          ),
          label: 'Explore',
        ),
      ],
    );
  }
}

// --- InfoCard WIDGET MODIFIED ---
// Reusable card widget now takes a function for its button press
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final IconData? buttonIcon;
  final bool hasGlobeIcon;
  final VoidCallback onButtonPressed; // <-- ADDED THIS

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onButtonPressed, // <-- ADDED THIS
    this.buttonIcon,
    this.hasGlobeIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xAAF7EAEF), Colors.white], // Adjusted gradient
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
            onPressed: onButtonPressed, // <-- USED THE CALLBACK HERE
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

// --- ALL WIDGETS BELOW ARE UNCHANGED ---

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
        _outputImagePath = 'assets/after.png'; // Make sure you have this asset
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
