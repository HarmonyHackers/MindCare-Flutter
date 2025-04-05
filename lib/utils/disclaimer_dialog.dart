import 'package:flutter/material.dart';
import 'package:mind_care/utils/custom_message_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DisclaimerDialog {
  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Disclaimer"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "This app uses your CPU to mine crypto during meditation usage implies consent and no financial guarantees.",
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  const termsUrl =
                      "https://docs.google.com/document/d/1mLG5e-zFMrsxrwDOO40X1vBYFelZGgMA6j_I4adLhyg/edit?usp=sharing";
                  if (await canLaunchUrl(Uri.parse(termsUrl))) {
                    await launchUrl(Uri.parse(termsUrl),
                        mode: LaunchMode.externalApplication);
                  } else {
                    CustomMessageNotifier.showSnackBar(
                      context,
                      "Could not open the link.",
                      onError: true,
                    );
                  }
                },
                child: const Text(
                  "View Terms and Conditions",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                const termsUrl =
                    "https://docs.google.com/document/d/1mLG5e-zFMrsxrwDOO40X1vBYFelZGgMA6j_I4adLhyg/edit?usp=sharing";
                if (await canLaunchUrl(Uri.parse(termsUrl))) {
                  await launchUrl(Uri.parse(termsUrl),
                      mode: LaunchMode.externalApplication);
                } else {
                  CustomMessageNotifier.showSnackBar(
                    context,
                    "Could not open the link.",
                    onError: true,
                  );
                }
              },
              child: const Text("Terms & Conditions"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setBool('disclaimerAccepted', true);
              },
              child: const Text("Okay"),
            ),
          ],
        );
      },
    );
  }
}
