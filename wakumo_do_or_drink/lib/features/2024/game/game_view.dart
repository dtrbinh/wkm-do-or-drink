import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wakumo_do_or_drink/data/model/PlayCard.dart';

import 'package:wakumo_do_or_drink/utils/AppColors.dart';
import 'package:wakumo_do_or_drink/utils/AppLoading.dart';

import '../../2023/edit_card/edit_card_view.dart';
import 'game_viewmodel.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> with TickerProviderStateMixin {
  late final AnimationController _animationController;

  final viewModel = Get.put(GameViewModel());
  bool isShowAppBar = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
      reverseDuration: const Duration(milliseconds: 1000),
    );

    _animationController.addListener(() {
      if (_animationController.isAnimating) {
        viewModel.onCardDrawing();
      } else if (_animationController.isCompleted) {
        viewModel.onCardOpened();
      } else if (_animationController.isDismissed) {
        viewModel.onCardClosed();
        if (!viewModel.isLoading.value) {
          debugPrint("is not loading, auto play");
          _animationController.forward();
        } else {
          debugPrint("is loading, ignore auto play");
        }
      }
    });

    viewModel.initAnimation((isDone) {
      if (!isDone) {
        AppLoading().showInternalError();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            _background(),
            Positioned(
              bottom: 16,
              right: 16,
              child: _wkmLogo(),
            ),
            _lottieCard(),
            Positioned(
              top: 16,
              right: 16,
              child: _refreshBtn(),
            ),
            Positioned(
              right: 16,
              child: _playBtn(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _background() {
    return Image.asset(
      'assets/images/background_2024.png',
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.cover,
    );
  }

  Widget _wkmLogo() {
    return Image.asset(
      "assets/images/wakumo_logo.png",
      width: MediaQuery.of(context).size.width * 0.15,
      fit: BoxFit.fitWidth,
    );
  }

  Widget _refreshBtn() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          viewModel.listPlayingCard.value.isEmpty
              ? Text(
                  "Out of card",
                  style: GoogleFonts.lobster(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20),
                )
              : const SizedBox.shrink(),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {
              _animationController.reverse();
              await viewModel.resetCards();
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.GREEN)),
              child: const Center(
                child: Icon(
                  Icons.refresh,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _playBtn() {
    return Obx(
      () => AbsorbPointer(
        absorbing: viewModel.isDrawing.value || viewModel.listPlayingCard.value.isEmpty,
        child: GestureDetector(
          onTap: () {
            drawCard();
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.15,
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: viewModel.isDrawing.value || viewModel.listPlayingCard.value.isEmpty ? Colors.grey : AppColors.GREEN),
            child: Center(
              child: Text(
                "Play",
                style: GoogleFonts.lobster(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _lottieCard() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.9,
        child: GestureDetector(
          onTap: () => viewModel.isCardOpened.value ? closeCard() : null,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Lottie.asset(
                'assets/lottie/random.json',
                controller: _animationController,
                onLoaded: (composition) {
                  _animationController.duration = composition.duration;
                },
                fit: BoxFit.contain,
              ),
              Obx(
                () => Visibility(
                  visible: viewModel.isCardOpened.value && viewModel.currentCard != null,
                  child: _cardContent(
                    viewModel.currentCard ??
                        PlayCard(
                          id: 0,
                          type: CardType.DO,
                          title: 'Please reset game!',
                          detail: 'No any card available',
                        ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _cardContent(PlayCard card) {
    if (card.id == 0) return const SizedBox.shrink();
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4.5,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            card.type == CardType.DO ? 'assets/images/hand_console.png' : 'assets/images/dual_beer.png',
            width: MediaQuery.of(context).size.width * 0.15,
            height: MediaQuery.of(context).size.height * 0.2,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.2),
            child: Text(
              card.detail,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lobster(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.2),
            child: Text(
              card.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lobster(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // region function draw card

  void drawCard() {
    if (_animationController.isCompleted) {
      // close card
      _animationController.reverse(); // consume 1500ms
    } else if (_animationController.isDismissed) {
      // draw card
      _animationController.forward(); // consume 3000ms
    } else if (_animationController.isAnimating) {
      //ignore
    }
  }

  void closeCard() {
    _animationController.reset();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
