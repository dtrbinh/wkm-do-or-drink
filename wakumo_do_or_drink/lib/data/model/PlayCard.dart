import 'dart:convert';
import 'dart:developer';

class PlayCard {
  late int id;
  late CardType type;
  late String title;
  late String detail;

  PlayCard({
    required this.id,
    required this.type,
    required this.title,
    required this.detail,
  });

  static PlayCard fromJson(Map json) {
    // var json = jsonDecode(jsonString);
    return PlayCard(
        id: int.parse(json['id']),
        type: parseCardType(json['type']),
        title: json['title'],
        detail: json['detail']);
  }

  Map<String, String> toJson() {
    return {
      'id': id.toString(),
      'type': type.toString(),
      'title': title.toString(),
      'detail': detail.toString()
    };
  }

  static CardType parseCardType(String json) {
    if (json == "CardType.DO") {
      return CardType.DO;
    } else if (json == "CardType.DRINK") {
      return CardType.DRINK;
    } else {
      return CardType.DO;
    }
  }
}

enum CardType { DO, DRINK }
