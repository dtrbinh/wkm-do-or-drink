import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wakumo_do_or_drink/data/model/PlayCard.dart';
import 'package:wakumo_do_or_drink/features/edit_card/edit_card_viewmodel.dart';
import 'package:wakumo_do_or_drink/utils/AppColors.dart';

class EditCardView extends StatefulWidget {
  const EditCardView({Key? key}) : super(key: key);

  @override
  State<EditCardView> createState() => _EditCardViewState();
}

class _EditCardViewState extends State<EditCardView> {
  final viewModel = Get.put(EditCardViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.GREEN,
        title: const Text(
          'EDIT',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(
        () => viewModel.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.all(16),
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    final card = viewModel.listDefaultCards.value[index];
                    return _cardEdit(card);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: viewModel.listDefaultCards.value.length,
                ),
              ),
      ),
    );
  }

  Widget _cardEdit(PlayCard item) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: 50,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.GREEN, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              item.id.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const VerticalDivider(
            width: 2,
            thickness: 1,
            color: AppColors.GREEN,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                item.detail,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Spacer(),
          Icon(item.type == CardType.DRINK ? Icons.bolt : Icons.gamepad),
        ],
      ),
    );
  }
}
