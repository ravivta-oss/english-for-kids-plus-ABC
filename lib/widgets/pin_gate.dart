import 'package:flutter/material.dart';

/// Simple 4-digit PIN gate used to keep kids out of "Parent Mode".
/// This is NOT real security — it's a lightweight speed bump so a
/// curious/frustrated child can't casually tap in and reset progress.
class PinGate {
  // Fixed on purpose per the family's request — not configurable in-app.
  static const String _correctPin = '1948';

  /// Shows a PIN entry dialog. Returns true if the correct PIN was
  /// entered, false if the user cancelled or entered the wrong PIN.
  static Future<bool> verify(BuildContext context) async {
    final controller = TextEditingController();
    String? error;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: const Text('קוד הורה'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('הזינו את קוד ההורה כדי להיכנס.'),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller,
                      autofocus: true,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, letterSpacing: 8),
                      decoration: InputDecoration(
                        counterText: '',
                        errorText: error,
                        border: const OutlineInputBorder(),
                      ),
                      onSubmitted: (_) {
                        if (controller.text == _correctPin) {
                          Navigator.pop(dialogContext, true);
                        } else {
                          setState(() => error = 'קוד שגוי, נסו שוב');
                        }
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: const Text('ביטול'),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (controller.text == _correctPin) {
                        Navigator.pop(dialogContext, true);
                      } else {
                        setState(() => error = 'קוד שגוי, נסו שוב');
                      }
                    },
                    child: const Text('כניסה'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    return result ?? false;
  }
}
