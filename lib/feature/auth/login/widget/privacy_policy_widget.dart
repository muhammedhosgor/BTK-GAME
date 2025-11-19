// MARK: - PRIVACY POLICY DIALOG WIDGET
import 'package:flutter/material.dart';
import 'package:flutter_base_app/product/components/button/primary_game_button.dart';
import 'package:flutter_base_app/product/components/container/gold_nav.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';

/// Privacy Policy dialog styled according to the game's theme.
class ThemedPrivacyPolicyDialog extends StatelessWidget {
  const ThemedPrivacyPolicyDialog({super.key});

  // Helper widget for policy section title and content
  Widget _buildPolicySection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: kSuitGold, // Gold-colored titles
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: kBlackColor, blurRadius: 2)],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            content,
            style: TextStyle(
              color: kWhiteColor.withOpacity(0.85),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double dialogWidth = MediaQuery.of(context).size.width * 0.9;

    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: dialogWidth,
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kTableNavy,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kSuitGold, width: 3),
            boxShadow: [
              BoxShadow(
                color: kBlackColor.withOpacity(0.8),
                spreadRadius: 5,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            // Background pattern
            image: DecorationImage(
              image: NetworkImage(
                  'https://placehold.co/600x900/${kTableNavy.value.toRadixString(16).substring(2, 8)}/${kSuitGold.value.toRadixString(16).substring(2, 8)}?text=PRIVACY'),
              fit: BoxFit.cover,
              opacity: 0.1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                "PRIVACY POLICY",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kSuitGold,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(color: kBlackColor.withOpacity(0.8), blurRadius: 5, offset: const Offset(1, 2)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const GoldNavContainer(),
              const SizedBox(height: 20),

              // Policy Content (Scrollable)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPolicySection(
                        title: "1. Collected Data",
                        content:
                            "The game collects data solely to provide and improve your in-game experience. These include: **Your In-Game Nickname**, **User ID**, **Game Progress** (levels, scores, statistics), and **Device Identifiers** (for performance analytics). We do NOT collect personally identifiable information such as your real name, surname, email address, or phone number.",
                      ),
                      _buildPolicySection(
                        title: "2. Use of Data",
                        content:
                            "Collected data is used to manage your account, display leaderboards, perform multiplayer matchmaking, resolve technical issues, and analyze game performance. Your data is not shared with advertising partners or third parties for profit.",
                      ),
                      _buildPolicySection(
                        title: "3. Security Measures",
                        content:
                            "We take necessary technical and administrative measures to protect your data from unauthorized access, alteration, disclosure, or destruction. All game data is stored encrypted on our servers.",
                      ),
                      _buildPolicySection(
                        title: "4. Data Retention and Deletion",
                        content:
                            "When you delete your account or request deletion, all your game data (except where legally required) will be permanently removed from our servers within a reasonable time.",
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "This policy was last updated on October 6, 2025.",
                        style: TextStyle(
                          color: kWhiteColor.withOpacity(0.7),
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Close Button
              PrimaryGameButton(
                buttonColor: kButtonGrey,
                text: 'OKAY',
                icon: Icons.policy,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
