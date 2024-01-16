import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:wakumo_do_or_drink/data/model/PlayCard.dart';
import 'package:wakumo_do_or_drink/utils/AppLoading.dart';

class HomeScreenViewModel extends GetxController {
  final animationSource = !kDebugMode ? 'assets/rive/shock_deer_animation.riv' : 'rive/shock_deer_animation.riv';
  final cardSource = !kDebugMode ? 'assets/default_card/default_card.json' : 'default_card/default_card.json';

  var listPlayingCard = [].obs;
  var listPlayedCard = [].obs;

  PlayCard? cardResult;

  //---
  var listSourceCard = [].obs;

  var isLoading = true.obs;
  var isShaking = false.obs;
  var isCardOpen = false.obs;

  Artboard? riveArtBoard;

  var open = SimpleAnimation('Open');
  var close = SimpleAnimation('Close');
  var shake = SimpleAnimation('Shake');

  PlayCard? get currentCard => cardResult;

  void initAnimation(Function(bool) onDone) async {
    try {
      rootBundle.load(animationSource).then((bytes) async {
        final artBoard = RiveFile.import(bytes).mainArtboard;
        riveArtBoard = artBoard;
        isLoading.value = false;
        update();
        await initCardData();
        onDone(true);
      });
    } catch (e) {
      debugPrint("Init animation error: ${e.toString()}");
      onDone(false);
    }
  }

  Future<void> initCardData() async {
    await loadSourceCard().then((value) => getPlayingCard());
  }

  // region control animation
  void shakeCard() {
    // debugPrint("shake card");
    removeAllAnimation();
    riveArtBoard!.addController(shake);
    update();
  }

  void openCard() {
    removeAllAnimation();
    riveArtBoard!.addController(open);
    update();
  }

  void closeCard() {
    isCardOpen.value = false;
    update();
    removeAllAnimation();
    riveArtBoard!.addController(close);
    update();
  }

  void startDrawClick() {
    debugPrint('----------Start');
    if (!isShaking.value) {
      isShaking.value = true;
      update();
      if (isCardOpen.value) {
        closeCard();
        Future.delayed(const Duration(milliseconds: 1500), () {
          startRandom();
        });
      } else {
        startRandom();
      }
    } else {
      debugPrint("Drawing!!!");
    }
  }

  void startRandom() {
    if (listPlayingCard.value.isNotEmpty) {
      shakeCard();
      Future.delayed(const Duration(seconds: 4), () {
        openCard();
        Future.delayed(const Duration(seconds: 1), () {
          getRandomCard();
          isShaking.value = false;
          isCardOpen.value = true;
          update();
        });
      });
    } else {
      debugPrint("Out of Card");
      cardResult = PlayCard(id: -1, type: CardType.DO, title: 'Please reset game!', detail: 'No any card available');
      update();
    }
  }

  void removeAllAnimation() {
    riveArtBoard!
      ..removeController(open)
      ..removeController(close)
      ..removeController(shake);
  }

  void resetCards() {
    if (isCardOpen.value) {
      closeCard();
      Future.delayed(const Duration(milliseconds: 1500), () => clearData());
    } else {
      clearData();
    }
  }
  // endregion

  ///--------logic
  Future<void> loadSourceCard() async {
    try {
      var listNewCard = [];
      await rootBundle.loadString(cardSource).then((response) async {
        final data = await json.decode(response);
        for (var rawCard in data) {
          var card = PlayCard.fromJson(rawCard);
          listNewCard.add(card);
        }
        listSourceCard.value.clear();
        listSourceCard.value.addAll(listNewCard);
        debugPrint('Get default card success: ${listSourceCard.value.length} cards');
        update();
      });
    } catch (e) {
      debugPrint("Get source card error: ${e.toString()}");
    }
  }

  void getPlayingCard({bool refreshSourceCard = false}) {
    if (refreshSourceCard) {
      loadSourceCard();
    }
    listPlayingCard.value.addAll(listSourceCard.value);
    isLoading.value = false;
    update();
  }

  void playedACard(PlayCard a) {
    listPlayingCard.value.remove(a);
    listPlayedCard.value.add(a);
    update();
  }

  void playedACardAt(int index) {
    listPlayedCard.value.add(listPlayingCard[index]);
    listPlayingCard.value.removeAt(index);
    update();
  }

  void clearData() {
    isLoading.value = false;
    isShaking.value = false;
    isCardOpen.value = false;
    listPlayedCard.value.clear();
    listPlayingCard.value.clear();
    update();
    debugPrint('${listPlayingCard.value.length} - ${listPlayedCard.value.length}');
    getPlayingCard();
    update();
    Get.showSnackbar(GetBar(
      message: "Completed!",
      duration: const Duration(milliseconds: 800),
    ));
  }

  void getRandomCard() {
    int randomIndex = Random().nextInt(listPlayingCard.value.length);
    var randomCard = listPlayingCard.value[randomIndex];
    playedACardAt(randomIndex);
    cardResult = randomCard;
    isCardOpen.value = true;
    debugPrint('Source Card: ${listSourceCard.value.length.toString()}');
    debugPrint('Played Card: ${listPlayedCard.value.length.toString()}');
    debugPrint('Available Card: ${listPlayingCard.value.length.toString()}');
    update();
  }
}

// wkm-do-or-drink.web.app
