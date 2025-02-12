import 'package:calendar_flutter/store/main/store.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class BoardTab extends StatelessWidget {
  const BoardTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();

    return store.boards.isNotEmpty
        ? Observer(
            builder: (_) => ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
              itemCount: store.boards.length,
              itemBuilder: (context, index) {
                final board = store.boards[index];
                return InfoCard(
                  data: board,
                );
              },
            ),
          )
        : const Center(
            child: DNText(
              title: 'Empty',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              opacity: .5,
            ),
          );
  }
}
