import 'package:rive/rive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wakumo_do_or_drink/data/model/PlayCard.dart';
import 'package:wakumo_do_or_drink/features/edit_card/edit_card_view.dart';
import 'package:wakumo_do_or_drink/features/home/home_screen_viewmodel.dart';
import 'package:wakumo_do_or_drink/utils/AppColors.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.title});

  final String title;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final viewModel = Get.put(HomeScreenViewModel());

  @override
  void initState() {
    super.initState();
    viewModel.initAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppColors.GREEN,
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   title: Text(
      //     widget.title,
      //     style: TextStyle(
      //         color: context.theme.scaffoldBackgroundColor,
      //         fontWeight: FontWeight.bold),
      //   ),
      // ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: GetBuilder<HomeScreenViewModel>(builder: (model) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/img_new_year.png',
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fitHeight,
              ),
              viewModel.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: GestureDetector(
                        onTap: () => viewModel.isCardOpen.value
                            ? viewModel.closeCard()
                            : null,
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Rive(
                              artboard: viewModel.riveArtBoard!,
                              fit: BoxFit.contain,
                            ),
                            Visibility(
                              visible: viewModel.isCardOpen.value,
                              child: _cardContent(viewModel.currentCard ??
                                  PlayCard(
                                      id: 0,
                                      type: CardType.DO,
                                      title: 'Please reset game!',
                                      detail: 'No any card available')),
                            )
                          ],
                        ),
                      )),
              Padding(
                padding:
                    const EdgeInsets.only(right: 20.0, bottom: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        viewModel.listPlayingCard.value.isEmpty
                            ? const Text(
                                "Out of card",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 20),
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            viewModel.resetCards();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.05,
                            height: MediaQuery.of(context).size.width * 0.05,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.GREEN)),
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
                    AbsorbPointer(
                      absorbing: viewModel.isShaking.value ||
                          viewModel.listPlayingCard.value.isEmpty,
                      child: GestureDetector(
                        onTap: () {
                          viewModel.startDrawClick();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: viewModel.isShaking.value ||
                                      viewModel.listPlayingCard.value.isEmpty
                                  ? Colors.grey
                                  : AppColors.GREEN),
                          child: const Center(
                            child: Text(
                              "Play",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/images/wakumo_logo.png",
                      width: MediaQuery.of(context).size.width * 0.15,
                      fit: BoxFit.fitWidth,
                    ),
                  ],
                ),
              )
            ],
          );
        }),
      ),
      drawer:
          _drawer(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _cardContent(PlayCard card) {
    if (card.id == 0) return const SizedBox.shrink();
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4.5,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            card.type == CardType.DO
                ? 'assets/images/hand_console.png'
                : 'assets/images/dual_beer.png',
            width: MediaQuery.of(context).size.width * 0.15,
            height: MediaQuery.of(context).size.height * 0.2,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          Expanded(
            child: Text(
              card.detail,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Expanded(
            child: Text(
              card.title,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawer() {
    return Container(
      width: MediaQuery.of(context).size.width / 5,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 5,
            height: MediaQuery.of(context).size.height / 5,
            padding: const EdgeInsets.all(16),
            color: AppColors.GREEN,
            child: const Center(
                child: Text(
              'Wakumo End Year Party',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            )),
          ),
          _drawerAction(Icons.settings, "Settings", () {}),
          _drawerAction(Icons.edit, "Edit Card Content", () {
            Navigator.pop(context);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const EditCardView()));
          }),
          _drawerAction(Icons.input, "Import Card Content", () {}),
          _drawerAction(Icons.output, "Export Card Content", () {}),
        ],
      ),
    );
  }

  Widget _drawerAction(IconData icon, String title, VoidCallback onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: MediaQuery.of(context).size.width / 5,
        height: MediaQuery.of(context).size.height / 10,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 16,
            ),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
