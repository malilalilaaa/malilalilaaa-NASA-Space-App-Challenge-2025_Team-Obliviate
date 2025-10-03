import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SarDataView extends StatelessWidget {
  const SarDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('sar_data_view'), // Key for AnimatedSwitcher
      children: [
        const SarImageProcessor(),
        const SizedBox(height: 24),
        InfoCard(
          icon: Icons.group_work_rounded,
          title: 'Research Community',
          description: 'Share your SAR datasets with researchers worldwide',
          buttonText: 'Upload & Share Dataset',
          buttonIcon: Icons.upload_rounded,
          onButtonPressed: () {
            // This would call a method in the parent, but for now, we can
            // define the dialog directly here or keep it in the main screen.
            // For simplicity, we can show a placeholder.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Upload functionality would go here."),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        InfoCard(
          icon: Icons.location_on_rounded,
          title: 'Select Your Location',
          description: 'Choose a city to analyze Sentinel-1 SAR imagery',
          buttonText: 'Select City',
          buttonIcon: Icons.my_location,
          hasGlobeIcon: true,
          onButtonPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Location selection would go here."),
              ),
            );
          },
        ),
      ],
    );
  }
}

// --- All supporting widgets for SarDataView ---

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
            children: [
              Icon(icon, color: Colors.blue.shade700),
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

class SarImageProcessor extends StatefulWidget {
  const SarImageProcessor({super.key});
  @override
  State<SarImageProcessor> createState() => _SarImageProcessorState();
}

class _SarImageProcessorState extends State<SarImageProcessor> {
  Uint8List? _inputImageBytes;
  bool _isProcessing = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _inputImageBytes = bytes);
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
                    ? const CircularProgressIndicator()
                    : Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.purple.shade300,
                        size: 28,
                      ),
              ),
              Expanded(
                child: _ImageContainer(
                  label: 'Processed Output',
                  child: Icon(
                    Icons.image_search_rounded,
                    size: 40,
                    color: Colors.grey.shade400,
                  ),
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
