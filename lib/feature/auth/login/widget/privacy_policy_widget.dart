// MARK: - PRIVACY POLICY DIALOG WIDGET
import 'package:flutter/material.dart';
import 'package:flutter_base_app/product/components/button/primary_game_button.dart';
import 'package:flutter_base_app/product/components/container/gold_nav.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';

/// Temaya uygun Gizlilik Politikası iletişim kutusu.
class ThemedPrivacyPolicyDialog extends StatelessWidget {
  const ThemedPrivacyPolicyDialog({super.key});

  // Politika bölüm başlığı ve içeriği için yardımcı widget
  Widget _buildPolicySection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: kSuitGold, // Başlıklar altın rengi
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
            // Arkaplan deseni
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
              // Başlık
              Text(
                "GİZLİLİK POLİTİKASI",
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

              // Politika İçeriği (Scrollable)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPolicySection(
                          title: "1. Toplanan Veriler",
                          content:
                              "Oyun, yalnızca oyun içi deneyiminizi sağlamak ve iyileştirmek amacıyla verileri toplar. Bu veriler: **Oyun İçi Takma Adınız**, **Kullanıcı Kimliğiniz (UserID)**, **Oyun İlerlemeniz** (Seviye, Puan, İstatistikler) ve **Cihaz Tanımlayıcıları** (performans analizi için) içerir. Kişisel kimliğinizi doğrudan ortaya çıkaracak (ad, soyad, e-posta, telefon numarası) bilgileri toplamıyoruz."),
                      _buildPolicySection(
                          title: "2. Verilerin Kullanımı",
                          content:
                              "Toplanan veriler, hesabınızı yönetmek, oyun içi sıralamaları göstermek, çok oyunculu eşleştirmeler yapmak, teknik sorunları gidermek ve oyunun performansını analiz etmek için kullanılır. Verileriniz, reklam ortakları veya üçüncü taraflarla kar amacı gütmeksizin paylaşılmaz."),
                      _buildPolicySection(
                          title: "3. Güvenlik Önlemleri",
                          content:
                              "Verilerinizi yetkisiz erişime, değişikliğe, ifşaya veya yok edilmeye karşı korumak için gerekli teknik ve idari önlemleri almaktayız. Tüm oyun verileri şifreli olarak sunucularımızda saklanır."),
                      _buildPolicySection(
                          title: "4. Veri Saklama ve Silme",
                          content:
                              "Hesabınızı sildiğinizde veya bizden silmemizi talep ettiğinizde, yasal zorunluluklar haricinde tüm oyun verileriniz makul bir süre içinde sunucularımızdan kalıcı olarak silinir."),
                      const SizedBox(height: 10),
                      Text(
                        "Bu politika, son olarak 06 Ekim 2025 tarihinde güncellenmiştir.",
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
                text: 'ANLADIM',
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
