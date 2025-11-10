// MARK: - HOW TO PLAY DIALOG WIDGET
import 'package:flutter/material.dart';
import 'package:flutter_base_app/product/components/button/primary_game_button.dart';
import 'package:flutter_base_app/product/components/container/gold_nav.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';

/// Temaya uygun 'Nasıl Oynanır' iletişim kutusu (Self-Contained Widget).
class ThemedHowToPlayDialog extends StatelessWidget {
  const ThemedHowToPlayDialog({super.key});

  // Kural başlığı ve içeriği için yardımcı widget
  Widget _buildRuleSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: kWhiteColor,
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
    // Dialog boyutunu ekranın yaklaşık %90'ı olarak ayarla.
    final double dialogWidth = MediaQuery.of(context).size.width * 0.9;

    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: dialogWidth,
          height: MediaQuery.of(context).size.height * 0.85, // Yüksekliği artırıldı
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
            // Hafif bir arkaplan deseni
            image: DecorationImage(
              image: NetworkImage(
                  'https://placehold.co/600x900/${kTableNavy.value.toRadixString(16).substring(2, 8)}/${kSuitGold.value.toRadixString(16).substring(2, 8)}?text=RULES'),
              fit: BoxFit.cover,
              opacity: 0.1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Başlık
              Text(
                "HOW TO PLAY: BASIC RULES",
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
              const GoldNavContainer(), // Altın ayırıcı
              const SizedBox(height: 20),

              // Kural İçeriği (Scrollable)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRuleSection(
                        title: "1. Game Objective",
                        content:
                            "The main goal of the game is to strategically use your cards to collect as many cards as possible. "
                            "Each player, on their turn, can either play a card or skip the round. "
                            "When you play a card, you draw the same number of cards from the center pile as the number of cards you played. "
                            "The player who collects the most cards by the end of the game wins.",
                      ),
                      _buildRuleSection(
                        title: "2. Game Structure and Turn System",
                        content: "The game is played online between two real players. "
                            "Each player is dealt a certain number of cards at the start. "
                            "Turns alternate between players. "
                            "When it’s your turn, you can choose between two actions:\n\n"
                            "• **Play Cards:** You may play one or more cards from your hand (up to three at a time). "
                            "For every card you play, you draw the same number of cards from the center pile.\n"
                            "• **Pass:** You can skip your turn without playing any cards.\n\n"
                            "Both players take turns performing actions. At the end of a round, all cards in the center pile are collected and a new round begins.",
                      ),
                      _buildRuleSection(
                        title: "3. Special Cards",
                        content:
                            "There are a total of 3 special cards in the game. These cards have unique effects that can alter the flow and balance of the match. "
                            "Each special card can only be used once, so timing and strategy are crucial:\n\n"
                            "• 🔁 **Swap Card:** Takes a random card from your opponent’s hand and gives one of your cards in return.\n"
                            "• 2X **Double Card:** Doubles the total value of all cards in the current round.\n"
                            "• 🌀 **Block Card:** Prevents your opponent from making a move on their next turn. They must pass that round.\n\n"
                            "When a special card is played, an animation (Lottie effect) is triggered to visually show its activation.",
                      ),
                      _buildRuleSection(
                        title: "4. Game Flow",
                        content: "Each player takes turns making moves. When a player plays cards:\n"
                            "1️⃣ They draw the same number of cards from the center pile.\n"
                            "2️⃣ The turn automatically passes to the other player.\n\n"
                            "When both players either finish their hands or choose to pass, the round ends. "
                            "The cards collected in that round are added to each player’s total. "
                            "After three rounds, the player who has collected the most cards wins the game.",
                      ),
                      _buildRuleSection(
                        title: "5. Online Connection and Room System",
                        content: "The game is played online between two real players. "
                            "Players can either create a room or join an existing one. "
                            "Once both players set their status to 'Ready', the game begins.",
                      ),
                      _buildRuleSection(
                        title: "6. Scoring System",
                        content:
                            "At the end of each round, players earn points based on the number of cards they have collected. "
                            "After three rounds, the player with the highest total score wins. "
                            "If both players have the same number of cards, the game ends in a draw and the result is displayed on the screen.",
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Note: There is no trump (koz) system in this game. Players can freely choose which cards to play or when to pass. "
                        "The gameplay is entirely based on strategy, card management, and using special cards at the right moment.",
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

              // Kapat Butonu
              PrimaryGameButton(
                buttonColor: kButtonGrey,
                text: 'I UNDERSTAND (CLOSE)',
                icon: Icons.check_circle_outline,
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
