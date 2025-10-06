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
                "NASIL OYNANIR: TEMEL KURALLAR",
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
                          title: "1. Oyunun Amacı",
                          content:
                              "Oyunun temel amacı, belirlenen **Koz** rengine göre taahhüt ettiğiniz sayıda el alabilmektir. Kazanılan her el, taahhüdünüzü gerçekleştirmeniz için önemlidir."),
                      _buildRuleSection(
                          title: "2. Kart Dağıtımı ve İhale",
                          content:
                              "52'lik deste her oyuncuya eşit olarak dağıtılır (Genellikle 13'er kart). Kartlar dağıtıldıktan sonra oyuncular, almayı taahhüt ettikleri el sayısını (İhale) belirler. En yüksek taahhüdü veren, koz rengini seçer."),
                      _buildRuleSection(
                          title: "3. El Oynama Zorunluluğu (Renk Mecburi)",
                          content:
                              "Oyuna başlayan oyuncunun attığı kartın rengini oynamak mecburidir. Elinizde o renkten kart yoksa, Koz renginden bir kart atarak eli almayı deneyebilir ya da farklı bir renkte kart atarak 'çakabilirsiniz'."),
                      _buildRuleSection(
                          title: "4. Koz Kartları",
                          content:
                              "Koz kartları, diğer tüm kartlardan üstündür. Eğer yerde Koz'dan daha yüksek bir kart yoksa, koz kartını atan oyuncu eli alır."),
                      _buildRuleSection(
                          title: "5. Puanlama Sistemi",
                          content:
                              "Taahhüt ettiğiniz el sayısını tamamlarsanız pozitif puan alırsınız. Taahhüt edilen el sayısına ulaşamazsanız veya taahhüdünüzü aşarsanız (Gömülen sayılmaz), ceza puanı hanenize yazılır."),
                      const SizedBox(height: 10),
                      Text(
                        "Not: Bu kurallar, temel Batak (İhaleli) kurallarına dayanmaktadır. Oyun modlarına göre ufak farklılıklar olabilir.",
                        style:
                            TextStyle(color: kWhiteColor.withOpacity(0.7), fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Kapat Butonu
              PrimaryGameButton(
                buttonColor: kButtonGrey,
                text: 'ANLADIM (KAPAT)',
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
