// MARK: - HOW TO PLAY DIALOG WIDGET
import 'package:flutter/material.dart';
import 'package:flutter_base_app/product/components/button/image_button.dart';
import 'package:flutter_base_app/product/components/button/primary_game_button.dart';
import 'package:flutter_base_app/product/components/container/gold_nav.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:video_player/video_player.dart';

/// Temaya uygun 'Nasıl Oynanır' iletişim kutusu (Self-Contained Widget).
class ThemedHowToPlayDialog extends StatefulWidget {
  const ThemedHowToPlayDialog({super.key});

  @override
  State<ThemedHowToPlayDialog> createState() => _ThemedHowToPlayDialogState();
}

class _ThemedHowToPlayDialogState extends State<ThemedHowToPlayDialog> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/game.mov')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

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
          height:
              MediaQuery.of(context).size.height * 0.85, // Yüksekliği artırıldı
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
              ImageButton(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (dialogContext) =>
                          VideoPlayerDialog(controller: _controller),
                    );
                  },
                  imagePath: 'assets/asset/video.png'),
              Text(
                "Watch Video",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kSuitGold,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                        color: kBlackColor.withOpacity(0.8),
                        blurRadius: 5,
                        offset: const Offset(1, 2)),
                  ],
                ),
              ),
              Text(
                "HOW TO PLAY:\nBASIC RULES",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kSuitGold,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                        color: kBlackColor.withOpacity(0.8),
                        blurRadius: 5,
                        offset: const Offset(1, 2)),
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
                        content:
                            "The game is played online between two real players. "
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
                        content:
                            "Each player takes turns making moves. When a player plays cards:\n"
                            "1️⃣ They draw the same number of cards from the center pile.\n"
                            "2️⃣ The turn automatically passes to the other player.\n\n"
                            "When both players either finish their hands or choose to pass, the round ends. "
                            "The cards collected in that round are added to each player’s total. "
                            "After three rounds, the player who has collected the most cards wins the game.",
                      ),
                      _buildRuleSection(
                        title: "5. Online Connection and Room System",
                        content:
                            "The game is played online between two real players. "
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

//! video player
class VideoPlayerDialog extends StatefulWidget {
  final VideoPlayerController controller;
  const VideoPlayerDialog({super.key, required this.controller});

  @override
  State<VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  bool _isPlaying = false;
  bool _isMuted = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isBuffering = false;

  @override
  void initState() {
    super.initState();
    // Ensure controller listeners are hooked
    widget.controller.addListener(_videoListener);
    _isPlaying = widget.controller.value.isPlaying;
    _duration = widget.controller.value.duration ?? Duration.zero;
  }

  void _videoListener() {
    final value = widget.controller.value;
    if (!mounted) return;
    setState(() {
      _isPlaying = value.isPlaying;
      _position = value.position;
      _duration = value.duration ?? Duration.zero;
      _isBuffering = value.isBuffering;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_videoListener);
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final minutes = two(d.inMinutes.remainder(60));
    final seconds = two(d.inSeconds.remainder(60));
    final hours = d.inHours;
    if (hours > 0) {
      return '${two(hours)}:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kTableNavy.withOpacity(0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header: Title + close
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'HOW TO PLAY — Video',
                      style: TextStyle(
                        color: kSuitGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        shadows: [
                          Shadow(
                              color: kBlackColor.withOpacity(0.6),
                              blurRadius: 3)
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () {
                      // pause on close for safety
                      if (widget.controller.value.isPlaying) {
                        widget.controller.pause();
                      }
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close, color: kWhiteColor),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Video area
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Video or placeholder if not initialized
                      if (widget.controller.value.isInitialized)
                        AspectRatio(
                          aspectRatio: widget.controller.value.aspectRatio,
                          child: VideoPlayer(widget.controller),
                        )
                      else
                        Container(
                          color: kBlackColor.withOpacity(0.6),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(kSuitGold),
                            ),
                          ),
                        ),

                      // buffering indicator
                      if (_isBuffering) const CircularProgressIndicator(),

                      // big play/pause overlay
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (widget.controller.value.isInitialized) {
                                if (widget.controller.value.isPlaying) {
                                  widget.controller.pause();
                                } else {
                                  widget.controller.play();
                                }
                              }
                            },
                            child: Center(
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: _isPlaying ? 0.0 : 1.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kBlackColor.withOpacity(0.45),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                    size: 44,
                                    color: kSuitGold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Progress + time
              if (widget.controller.value.isInitialized) ...[
                VideoProgressIndicator(
                  widget.controller,
                  allowScrubbing: true,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: TextStyle(color: kWhiteColor.withOpacity(0.85)),
                    ),
                    const Spacer(),
                    Text(
                      _formatDuration(_duration),
                      style: TextStyle(color: kWhiteColor.withOpacity(0.85)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],

              // Controls row
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (!widget.controller.value.isInitialized) return;
                      if (widget.controller.value.isPlaying) {
                        widget.controller.pause();
                      } else {
                        widget.controller.play();
                      }
                    },
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      size: 32,
                      color: kSuitGold,
                    ),
                  ),

                  const SizedBox(width: 8),

                  IconButton(
                    onPressed: () {
                      if (!widget.controller.value.isInitialized) return;
                      // rewind 5s
                      final newPos = widget.controller.value.position -
                          const Duration(seconds: 5);
                      widget.controller.seekTo(
                          newPos >= Duration.zero ? newPos : Duration.zero);
                    },
                    icon: const Icon(Icons.replay_5, color: kWhiteColor),
                  ),

                  IconButton(
                    onPressed: () {
                      if (!widget.controller.value.isInitialized) return;
                      // forward 5s
                      final newPos = widget.controller.value.position +
                          const Duration(seconds: 5);
                      widget.controller
                          .seekTo(newPos <= _duration ? newPos : _duration);
                    },
                    icon: const Icon(Icons.forward_5, color: kWhiteColor),
                  ),

                  const Spacer(),

                  IconButton(
                    tooltip: _isMuted ? 'Unmute' : 'Mute',
                    onPressed: () {
                      if (!widget.controller.value.isInitialized) return;
                      setState(() {
                        _isMuted = !_isMuted;
                        widget.controller.setVolume(_isMuted ? 0.0 : 1.0);
                      });
                    },
                    icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up,
                        color: kWhiteColor),
                  ),

                  const SizedBox(width: 6),

                  // Fullscreen button (opens new route with same controller)
                  IconButton(
                    tooltip: 'Fullscreen',
                    onPressed: () async {
                      if (!widget.controller.value.isInitialized) return;
                      final wasPlaying = widget.controller.value.isPlaying;
                      // Pause briefly to avoid duplicate playback issues
                      widget.controller.pause();
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => _FullscreenVideoPage(
                              controller: widget.controller),
                        ),
                      );
                      // resume if it was playing before
                      if (wasPlaying) widget.controller.play();
                    },
                    icon: const Icon(Icons.fullscreen, color: kWhiteColor),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Close button (explicit)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kSuitRed,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (widget.controller.value.isPlaying) {
                      widget.controller.pause();
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, color: kWhiteColor),
                      SizedBox(width: 8),
                      Text('GOT IT — CLOSE',
                          style: TextStyle(color: kWhiteColor)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fullscreen page used by the dialog's fullscreen button
class _FullscreenVideoPage extends StatefulWidget {
  final VideoPlayerController controller;
  const _FullscreenVideoPage({required this.controller});

  @override
  State<_FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<_FullscreenVideoPage> {
  @override
  void initState() {
    super.initState();
    // ensure landscape if you want, but leaving orientation handling to the app is safer
    if (!widget.controller.value.isPlaying) widget.controller.play();
  }

  @override
  void dispose() {
    // do not dispose controller here — owner widget disposes it
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: widget.controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: widget.controller.value.aspectRatio,
                      child: VideoPlayer(widget.controller),
                    )
                  : const CircularProgressIndicator(),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
