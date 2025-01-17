import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/create/store/create.dart';
import 'package:calendar_flutter/ui/views/create/ui/action_button.dart';
import 'package:calendar_flutter/ui/views/create/ui/form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage>
    with SingleTickerProviderStateMixin {
  late final _tabController =
      TabController(length: 2, vsync: this, initialIndex: 0);
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => CreateStoreLocal(),
      child: Scaffold(
        key: scaffoldKey,
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
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.amberAccent,
                  unselectedLabelColor: Colors.white54,
                  labelColor: Colors.amberAccent,
                  overlayColor: WidgetStateProperty.all(
                    Colors.amberAccent.withOpacity(0.1),
                  ),
                  tabs: [
                    Tab(
                      child: DNText(
                        title: 'Tasks',
                        fontSize: 20,
                        color: _tabController.index == 0
                            ? Colors.amberAccent
                            : Colors.white,
                      ),
                    ),
                    Tab(
                      child: DNText(
                        title: 'Boards',
                        fontSize: 20,
                        color: _tabController.index == 1
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
                      controller: _tabController,
                      children: const [
                        DNForm(isTask: true),
                        DNForm(isTask: false),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton:
            ActionButton(controller: _tabController, scaffoldKey: scaffoldKey),
      ),
    );
  }
}
