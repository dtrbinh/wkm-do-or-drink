import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wakumo_do_or_drink/data/model/PlayCard.dart';

class GameViewModel extends GetxController {
  final animationSource = !kDebugMode ? 'assets/rive/shock_deer_animation.riv' : 'rive/shock_deer_animation.riv';
  final cardSource = !kDebugMode ? 'assets/default_card/cards_2024.json' : 'assets/default_card/cards_2024.json';


  PlayCard? cardResult;

  //---
  RxList<PlayCard> listSourceCard = <PlayCard>[].obs; // card load from json
  RxList<PlayCard> listPlayingCard = <PlayCard>[].obs; // card available to play
  RxList<PlayCard> listPlayedCard = <PlayCard>[].obs; // card played

  var isLoading = true.obs;

  var isDrawing = false.obs;
  var isCardOpened = false.obs;

  PlayCard? get currentCard => cardResult;

  void initAnimation(Function(bool) onDone) async {
    try {
      isLoading.value = true;
      await initCardData();
      isLoading.value = false;
      onDone(true);
    } catch (e) {
      debugPrint("Init animation error: ${e.toString()}");
      onDone(false);
    }
  }

  Future<void> initCardData() async {
    await loadSourceCard();
    getPlayingCard(refreshSourceCard: false);
  }

  // region control animation
  void onCardDrawing() {
    isDrawing.value = true;
    isCardOpened.value = false;
    update();
    // debugPrint("Card is shaking");
  }

  void onCardOpened() {
    isDrawing.value = false;
    isCardOpened.value = true;
    update();
    debugPrint("Card is opened");
    startRandom();
  }

  void onCardClosed() {
    isDrawing.value = false;
    isCardOpened.value = false;
    update();
    debugPrint("Card is closed. Continue to draw");
  }

  void startRandom() {
    if (listPlayingCard.isNotEmpty) {
      getRandomCard();
      isDrawing.value = false;
      isCardOpened.value = true;
      update();
    } else {
      debugPrint("Out of Card");
      cardResult = PlayCard(id: -1, type: CardType.DO, title: 'Please reset game!', detail: 'No any card available');
      update();
    }
  }

  Future<void> resetCards() async {
    isLoading.value = true;
    var msDelay = 1100;
    if (isCardOpened.value) {
      msDelay = 1100;
    } else {
      msDelay = 100;
    }
    await Future.delayed(Duration(milliseconds: msDelay), () => clearData());


    isLoading.value = false;
  }
  // endregion

  ///--------logic
  Future<void> loadSourceCard() async {
    try {
      debugPrint("Card source: $cardSource");
      await rootBundle.loadString(cardSource).then((response) async {
        final List data = await json.decode(response);
        final listNewCard = data.map((cardJson) => PlayCard.fromJson(cardJson)).toList();

        listSourceCard.clear();
        listSourceCard.addAll(listNewCard);
        debugPrint('Get default card success: ${listSourceCard.length} cards');
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
    listPlayingCard.addAll(listSourceCard);
    isLoading.value = false;
    update();
  }

  void playedACard(PlayCard a) {
    listPlayingCard.remove(a);
    listPlayedCard.add(a);
    update();
  }

  void playedACardAt(int index) {
    listPlayedCard.add(listPlayingCard[index]);
    listPlayingCard.removeAt(index);
    update();
  }

  void clearData() {
    isLoading.value = false;
    isDrawing.value = false;
    isCardOpened.value = false;
    listPlayedCard.clear();
    listPlayingCard.clear();
    update();
    debugPrint('${listPlayingCard.length} - ${listPlayedCard.length}');
    getPlayingCard(refreshSourceCard: true);
    update();
    Get.showSnackbar(const GetSnackBar(
      message: "Completed!",
      duration: Duration(milliseconds: 800),
    ));
  }

  void getRandomCard() {
    int randomIndex = Random().nextInt(listPlayingCard.length);
    var randomCard = listPlayingCard[randomIndex];
    playedACardAt(randomIndex);
    cardResult = randomCard;
    isCardOpened.value = true;
    debugPrint("Card: ${cardResult!.title}");
    debugPrint('Source Card: ${listSourceCard.length.toString()}');
    debugPrint('Played Card: ${listPlayedCard.length.toString()}');
    debugPrint('Available Card: ${listPlayingCard.length.toString()}');
    update();
  }
}

// wkm-do-or-drink.web.app
