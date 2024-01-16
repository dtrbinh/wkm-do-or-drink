import 'package:get/get.dart';

class EditCardViewModel extends GetxController {
  var isLoading = true.obs;
  RxList listDefaultCards = [].obs;

  void initData() {
    initDefaultCard();
  }

  void initDefaultCard() async {}
}
// {
//    "id": "3",
//    "type": "CardType.DRINK",
//    "title": "Drink with those who are still single",
//    "detail": "Uống với tất cả những người còn độc thân"
//  },
//  {
//    "id": "4",
//    "type": "CardType.DRINK",
//    "title": "Drink with those who got married",
//    "detail": "Uống với tất cả những người đã kết hôn"
//  },
//  {
//    "id": "5",
//    "type": "CardType.DRINK",
//    "title": "Drink with 3 people",
//    "detail": "Uống cùng với 3 người nào tuỳ thích"
//  },
//  {
//    "id": "6",
//    "type": "CardType.DO",
//    "title": "Play a game with 4 person you want",
//    "detail": "Chơi game với 4 người bạn muốn"
//  },
//  {
//    "id": "7",
//    "type": "CardType.DRINK",
//    "title": "Drink with the youngest and the oldest",
//    "detail": "Uống cùng với người trẻ tuổi nhất và lớn tuổi nhất"
//  },
//  {
//    "id": "8",
//    "type": "CardType.DRINK",
//    "title": "Drink with people same age with you",
//    "detail": "Uống cùng với người cùng tuổi với bạn"
//  },
//  {
//    "id": "9",
//    "type": "CardType.DRINK",
//    "title": "Drink with those whose different gender with you",
//    "detail": "Uống cùng với tất cả người khác giới với bạn"
//  },
//  {
//    "id": "10",
//    "type": "CardType.DRINK",
//    "title": "Drink with who older than you",
//    "detail": "Uống cùng ai lớn tuổi hơn bạn"
//  },
//  {
//    "id": "11",
//    "type": "CardType.DRINK",
//    "title": "Drink with people opposite you",
//    "detail": "Uống cùng với người đối diện"
//  },
//  {
//    "id": "12",
//    "type": "CardType.DRINK",
//    "title": "Drink with people younger than you",
//    "detail": "Uống với bất kì ai trẻ tuổi hơn bạn"
//  },
//  {
//    "id": "13",
//    "type": "CardType.DO",
//    "title": "Play a game with 2 people next to you (not your partner)",
//    "detail": "Chơi 1 trò chơi vs 2 người ngồi bên cạnh bạn (không phải là người đi cùng)"
//  },
//  {
//    "id": "14",
//    "type": "CardType.DO",
//    "title": "People who has a kids play a game",
//    "detail": "Những người đã có con chơi một trò chơi"
//  },
//  {
//    "id": "15",
//    "type": "CardType.DO",
//    "title": "Play a game with 3 people opposite you",
//    "detail": "Chơi một trò chơi với 3 người đối diện bạn"
//  },
//  {
//    "id": "16",
//    "type": "CardType.DO",
//    "title": "Play a game with 3 members you want",
//    "detail": "Chơi một trò chơi với 3 người bạn muốn"
//  },
//  {
//    "id": "17",
//    "type": "CardType.DO",
//    "title": "Play a game with who wear glasses",
//    "detail": "Chơi game với những người mang kính"
//  },
//  {
//    "id": "18",
//    "type": "CardType.DO",
//    "title": "Play a game with people sit at the corner of the table",
//    "detail": "Chơi một trò chơi với những người ngồi ở góc bàn"
//  },
//  {
//    "id": "19",
//    "type": "CardType.DRINK",
//    "title": "Drink with all",
//    "detail": "Uống với tất cả mọi người"
//  },
//  {
//    "id": "20",
//    "type": "CardType.DRINK",
//    "title": "Count 1,2,3 to the end of the table. Start from you. Number 1 will drink",
//    "detail": "Đếm số 1,2,3 bắt đầu từ bạn. Ai số 1 sẽ cùng nhau uống"
//  },
//  {
//    "id": "21",
//    "type": "CardType.DO",
//    "title": "Count 1-5 till the end of the table. Start from you. Play with those who are number 1",
//    "detail": "Đếm số 1,2,3,4,5 bắt đầu từ bạn. Ai số 1 sẽ cùng nhau chơi một trò chơi"
//  },
//  {
//    "id": "22",
//    "type": "CardType.DRINK",
//    "title": "Drink with someone you want",
//    "detail": "Uống với 1 người bạn muốn"
//  },
//  {
//    "id": "23",
//    "type": "CardType.DRINK",
//    "title": "Drink with all those who sitting on opposite side of you",
//    "detail": "Uống với tất cả những người ngồi phía đối diện bạn"
//  },
//  {
//    "id": "24",
//    "type": "CardType.DRINK",
//    "title": "Drink with those who are shorter than you",
//    "detail": "Uống với ai thấp hơn bạn"
//  },
//  {
//    "id": "25",
//    "type": "CardType.DRINK",
//    "title": "Read the full name of all the people in Wakumo, if you could not, drink the beer.",
//    "detail": "Đọc đầy đủ họ và tên của mọi người trong công ty, nếu bạn không thể đọc được, uống một ly"
//  },
//  {
//    "id": "26",
//    "type": "CardType.DRINK",
//    "title": "Drink with those who are taller than you",
//    "detail": "Uống với ai cao hơn bạn"
//  }