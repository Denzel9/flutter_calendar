import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/create/store/create.dart';
import 'package:calendar_flutter/ui/views/create/ui/action_button.dart';
import 'package:calendar_flutter/ui/views/create/ui/assign.dart';
import 'package:calendar_flutter/ui/views/create/ui/main.dart';
import 'package:calendar_flutter/ui/views/create/ui/media.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePage extends StatefulWidget {
  final String? selectedBoard;
  final int? selectedIndex;

  const CreatePage({
    super.key,
    this.selectedBoard,
    this.selectedIndex,
  });

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.selectedIndex ?? 0);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => CreateStoreLocal(),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorDark,
          leading: BackButton(
            color: Theme.of(context).primaryColor,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                TabBar(
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.amberAccent,
                  unselectedLabelColor: Colors.white54,
                  labelColor: Colors.amberAccent,
                  overlayColor: WidgetStateProperty.all(
                      Colors.amberAccent.withAlpha((0.1 * 255).toInt())),
                  tabs: [
                    Tab(
                      child: DNText(
                        title: 'Tasks',
                        fontSize: 20,
                        color: tabController.index == 0
                            ? Colors.amberAccent
                            : Colors.white,
                      ),
                    ),
                    Tab(
                      child: DNText(
                        title: 'Boards',
                        fontSize: 20,
                        color: tabController.index == 1
                            ? Colors.amberAccent
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        ListView(
                          children: [
                            Main(
                              isTask: true,
                              selectedBoard: widget.selectedBoard,
                            ),
                            const Assign(),
                            const Media()
                          ],
                        ),
                        ListView(
                          children: const [
                            Main(isTask: false),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: ActionButton(controller: tabController),
      ),
    );
  }
}
