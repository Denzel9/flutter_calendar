import 'package:calendar_flutter/ui/views/create/create.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      clipBehavior: Clip.antiAlias,
      onPressed: () => showModalBottomSheetDN(context),
      child: InkWell(
        splashColor: Colors.white10,
        child: Ink(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/pattern.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.amberAccent.shade200, BlendMode.multiply),
            ),
          ),
          child: const Icon(
            Icons.add,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

Future<dynamic>? showModalBottomSheetDN(BuildContext context) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Theme.of(context).primaryColorDark,
    context: context,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 1,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 60),
          child: const CreatePage(),
        ),
      );
    },
  );
}
