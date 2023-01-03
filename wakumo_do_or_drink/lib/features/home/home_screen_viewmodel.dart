import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:wakumo_do_or_drink/data/model/PlayCard.dart';

class HomeScreenViewModel extends GetxController {
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

  void initAnimation() {
    //remove assets/ when debug, add it when deploy
    rootBundle.load('assets/rive/shock_deer_animation.riv').then((bytes) {
      final artBoard = RiveFile.import(bytes).mainArtboard;
      // artBoard.addController(shake);
      riveArtBoard = artBoard;
      isLoading.value = false;
      update();
      initData();
    });
  }

  void initData() async {
    await getSourceCard().then((value) => getPlayingCard());
  }

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
      cardResult = PlayCard(
          id: -1,
          type: CardType.DO,
          title: 'Please reset game!',
          detail: 'No any card available');
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

  ///--------logic
  Future<void> getSourceCard() async {
    try {
      var listNewCard = [];
      //remove assets/ when debug, add it when deploy
      await rootBundle
          .loadString('assets/default_card/default_card.json')
          .then((response) async {
        final data = await json.decode(response);
        for (var rawCard in data) {
          var card = PlayCard.fromJson(rawCard);
          listNewCard.add(card);
        }
        listSourceCard.value.clear();
        listSourceCard.value.addAll(listNewCard);
        debugPrint('Get success: ${listSourceCard.value.length} cards');
        update();
      });
    } catch (e) {
      debugPrint("Get source card error: ${e.toString()}");
    }
  }

  void getPlayingCard({bool refreshSourceCard = false}) {
    if (refreshSourceCard) {
      getSourceCard();
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
    debugPrint(
        '${listPlayingCard.value.length} - ${listPlayedCard.value.length}');
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
