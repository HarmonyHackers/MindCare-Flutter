import 'package:flutter/material.dart';
import 'package:mind_care/utils/custom_message_notifier.dart';
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
                "Welcome! Before you continue, please review our Terms and Conditions.",
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  // TODO: Add link of doc
                  const termsUrl = "https://yourtermsandconditions.com";
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
                // TODO: Add link of doc
                const termsUrl = "https://yourtermsandconditions.com";
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
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Okay"),
            ),
          ],
        );
      },
    );
  }
}
