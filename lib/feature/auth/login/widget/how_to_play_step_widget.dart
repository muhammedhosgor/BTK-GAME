import 'package:flutter/material.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_cubit.dart';
import 'package:flutter_base_app/feature/auth/login/widget/how_to_play_widget.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class HowToPlayStepDialog extends StatefulWidget {
  const HowToPlayStepDialog({super.key});

  @override
  State<HowToPlayStepDialog> createState() => _HowToPlayStepDialogState();
}

class _HowToPlayStepDialogState extends State<HowToPlayStepDialog> {
  int currentStep = 0;

  final List<Map<String, String>> steps = [
    {
      'title': 'Step 1: Start Game',
      'description':
          'Hello, In this video, I quickly explain how to play our game. While you are on the Login Scren you can enter the game area by saying Start Game',
      'video': 'assets/video/startGame1.mp4',
    },
    {
      'title': 'Step 2: Create Game',
      'description':
          'On the game selection screen that opens, you can create a game and then you will be directed to waiting area.',
      'video': 'assets/video/createGame1.mp4',
    },
    {
      'title': 'Step 3: Join Game',
      'description':
          'On the game selection screen, you can join an existing game by selecting one, and then you will be directed to the game area.',
      'video': 'assets/video/joinGame1.mp4',
    },
    {
      'title': 'Step 4: Play Game',
      'description':
          'The game is played with a deck of 52 cards. Each player starts with 5 cards dealt randomly. Player can exchange up to 3 of their cards with the deck in the middle to achieve the highest total, or they can choose to pass without exchanging any cards. ',
      'video': 'assets/video/playGame1.mp4',
    },
    {
      'title': 'Step 5: Special Cards (2X)',
      'description':
          'If you draw a 2x card, the total of the cards in your hands is multipled by 2.',
      'video': 'assets/video/2xCard1.mp4',
    },
    {
      'title': 'Step 6: Special Cards\n(Swapped Card)',
      'description':
          """If a Swapped card appears in the game, you can choose one of your own cards and one card from your opponent's hand, and then swap the selected cards with your oppenent. """,
      'video': 'assets/video/swappedCard1.mp4',
    },
    {
      'title': 'Step 7: Special Cards\n(Disable Card)',
      'description':
          """If a Disable card is played, you can select one of the oppenent's cards and deactivate it, reducing their total card value  by the value of the deactivated card.""",
      'video': 'assets/video/disableCard1.mp4',
    },
    {
      'title': 'Step 8: Final - Finish Game',
      'description':
          'In a game consisting of 3 raounds the player who wins the most rounds is declared the winner.',
      'video': 'assets/video/final1.mp4',
    },
  ];

  late VideoPlayerController _controller;
  bool _showPlayButton = true;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() {
    _controller = VideoPlayerController.asset(steps[currentStep]['video']!)
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.addListener(() {
      if (!mounted) return;
      setState(() {
        // Büyük ortadaki play butonu sadece video duruyorsa gözüksün
        _showPlayButton = !_controller.value.isPlaying;
      });
    });
  }

  void _nextStep() {
    if (currentStep < steps.length - 1) {
      _controller.dispose();
      setState(() {
        currentStep++;
      });
      _loadVideo();
    }
  }

  void _prevStep() {
    if (currentStep > 0) {
      _controller.dispose();
      setState(() {
        currentStep--;
      });
      _loadVideo();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kTableNavy,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Başlık
            Row(
              children: [
                Text(
                  steps[currentStep]['title']!,
                  style: const TextStyle(
                    color: kSuitGold,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Container(
                  decoration: const BoxDecoration(
                    color: kCardCream,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                            value: LoginCubit(),
                            child: const ThemedHowToPlayDialog(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.info,
                        size: 30.sp,
                        color: Colors.black,
                      )),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Video
            if (_controller.value.isInitialized)
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            _controller.play();
                          }
                        });
                      },
                      child: VideoPlayer(_controller),
                    ),
                    if (_showPlayButton)
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.play_arrow,
                            color: kSuitGold,
                            size: 56,
                          ),
                          onPressed: () {
                            _controller.play();
                          },
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        colors: const VideoProgressColors(
                          playedColor: kSuitGold,
                          backgroundColor: Colors.white30,
                          bufferedColor: Colors.white54,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 24,
                      right: 16,
                      child: Text(
                        '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                height: 200,
                color: Colors.black12,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            const SizedBox(height: 12),
            // Açıklama
            Text(
              steps[currentStep]['description']!,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // İleri/Geri
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentStep > 0)
                  ElevatedButton(
                    onPressed: _prevStep,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kSuitGold.withOpacity(0.8)),
                    child: const Text(
                      'Previous',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                else
                  const SizedBox(width: 100),
                if (currentStep < steps.length - 1)
                  ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kSuitGold.withOpacity(0.8)),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSuitRed,
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
