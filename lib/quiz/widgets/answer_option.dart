import 'package:flutter/material.dart';

class AnswerOption extends StatelessWidget {
  final String optionText;
  final bool isSelected;
  final bool isCorrect;
  final bool isSubmitted;
  final VoidCallback onTap;

  const AnswerOption({
    super.key,
    required this.optionText,
    required this.isSelected,
    required this.isCorrect,
    required this.isSubmitted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _getBorderColor(), width: 2),
        ),
        child: Row(
          children: [
            Icon(
              _getIcon(),
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                optionText,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isSubmitted) {
      if (isCorrect) return Colors.green.shade100;
      if (isSelected && !isCorrect) return Colors.red.shade100;
    }
    if (isSelected) {
      return Colors.deepPurple.shade300;
    }
    return Colors.white;
  }

  Color _getBorderColor() {
    if (isSubmitted) {
      if (isCorrect) return Colors.green;
      if (isSelected && !isCorrect) return Colors.red;
    }
    if (isSelected) {
      return Colors.deepPurple;
    }
    return Colors.grey.shade300;
  }

  IconData _getIcon() {
    if (isSubmitted) {
      if (isCorrect) return Icons.check_circle;
      if (isSelected && !isCorrect) return Icons.cancel;
    }
    return isSelected
        ? Icons.radio_button_checked
        : Icons.radio_button_unchecked;
  }
}
