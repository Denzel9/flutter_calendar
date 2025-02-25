import 'package:calendar_flutter/ui/views/create/create.dart';
import 'package:calendar_flutter/ui/views/home/store/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final HomeStoreLocal homeStoreLocal = context.watch<HomeStoreLocal>();

    return FloatingActionButton(
      clipBehavior: Clip.antiAlias,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreatePage(
                  selectedIndex: homeStoreLocal.tabIndex,
                )),
      ),
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
