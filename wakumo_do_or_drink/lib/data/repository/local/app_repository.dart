import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wakumo_do_or_drink/data/model/PlayCard.dart';

class AppRepository extends GetxController {
  var listPlayingCard = [].obs;
  var listPlayedCard = [].obs;

  //---
  var listSourceCard = [].obs;
  var isLoading = true.obs;

  void initData() async {
    await getSourceCard().then((value) => getPlayingCard());
  }

  Future<void> getSourceCard() async {
    try {
      await rootBundle
          .loadString('default_card/default_card.json')
          .then((response) async {
        final data = await json.decode(response);
        for (var raw in data) {
          listSourceCard.value.add(PlayCard.fromJson(raw));
        }
        update();
      });
    } catch (e) {
      debugPrint("Get source card error: ${e.toString()}");
    }
  }

  void getPlayingCard() {
    listPlayingCard.value = listSourceCard.value;
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

  void reset() {
    isLoading.value = true;
    update();
    listPlayingCard.value = [];
    listPlayedCard.value = [];
    getPlayingCard();
  }

  PlayCard getRandomCard() {
    int randomIndex = Random().nextInt(listPlayingCard.value.length);
    var randomCard = listPlayingCard.value[randomIndex];
    playedACardAt(randomIndex);
    return randomCard;
  }
}
