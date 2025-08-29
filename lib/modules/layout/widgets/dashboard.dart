import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'accounts_first_card.dart';
import 'accounts_second_card.dart';
import 'app_text.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 116,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return index == 0 ? AccountsFirstCard() : AccountsSecondCard();
            },
            itemCount: 2,
            autoplay: true,
          ),
        ),
        AppText(),
      ],
    );
  }
}
