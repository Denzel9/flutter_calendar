import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_flutter/store/task/task.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/widgets/info_card.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:calendar_flutter/utils/filter_tasks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/board.dart';

enum SampleItem { delete, active, done }

class BoardViewPage extends StatefulWidget {
  final Board board;

  const BoardViewPage({super.key, required this.board});

  @override
  State<BoardViewPage> createState() => _BoardViewStatePage();
}

class _BoardViewStatePage extends State<BoardViewPage>
    with SingleTickerProviderStateMixin {
  final editController = TextEditingController();
  final controller = ScrollController();
  late TaskStore _taskStore;
  late final _tabController =
      TabController(length: 2, vsync: this, initialIndex: 0);
  bool isActiveTask = true;
  bool isAllTask = true;

  @override
  void didChangeDependencies() {
    _taskStore = Provider.of<TaskStore>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    editController.dispose();
    controller.dispose();
    isActiveTask = true;
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      minChildSize: .7,
      maxChildSize: 1,
      expand: false,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.only(top: 80),
        decoration: const BoxDecoration(color: Color.fromARGB(255, 58, 58, 58)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DNIconButton(
                      icon: const Icon(
                        Icons.arrow_downward,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.amberAccent,
                      onClick: () => Navigator.pop(context)),
                  PopupMenuButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.amberAccent),
                        foregroundColor: WidgetStatePropertyAll(Colors.black)),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: SampleItem.delete,
                        onTap: () {
                          // taskService.dele(widget.board.docId);
                          Navigator.pop(context);
                        },
                        child: const DNText(
                          title: 'Delete',
                          color: Colors.black,
                        ),
                      ),
                      PopupMenuItem(
                        value: isAllTask ? SampleItem.active : SampleItem.done,
                        onTap: () =>
                            setState(() => isActiveTask = !isActiveTask),
                        child: DNText(
                          title: isActiveTask ? "Done" : 'Active',
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            TabBar(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              onTap: (value) => setState(() {}),
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.amberAccent,
              unselectedLabelColor: Colors.white54,
              labelColor: Colors.amberAccent,
              overlayColor:
                  WidgetStateProperty.all(Colors.amberAccent.withOpacity(0.1)),
              tabs: [
                Tab(
                  height: 50,
                  child: DNText(
                    title: '${_taskStore.tasks.length} Tasks',
                    fontSize: 25,
                    color: _tabController.index == 0
                        ? Colors.amberAccent
                        : Colors.white,
                  ),
                ),
                Tab(
                  height: 50,
                  child: DNText(
                    title: 'Information',
                    fontSize: 25,
                    color: _tabController.index == 1
                        ? Colors.amberAccent
                        : Colors.white,
                  ),
                )
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: filteredTaskToBoard(widget.board.title).length,
                      itemBuilder: (context, index) {
                        final task =
                            filteredTaskToBoard(widget.board.title)[index];
                        return InfoCard(
                          data: task,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ListView(
                      children: [
                        const DNText(
                          title: 'Board',
                          opacity: .5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: AutoSizeText(widget.board.title,
                              style: const TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  height: 1.2,
                                  fontWeight: FontWeight.bold),
                              minFontSize: 18,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DNText(
                              title: 'CreatedAt',
                              opacity: .5,
                            ),
                            DNText(
                              title: 'Assignee',
                              opacity: .5,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DNText(
                              title: getFormatDate(widget.board.createdAt),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.centerRight,
                                children: [
                                  Positioned(
                                      child: CircleAvatar(
                                          backgroundColor: Colors.red)),
                                  Positioned(
                                    right: 25,
                                    child: CircleAvatar(
                                        backgroundColor: Colors.black),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const DNText(
                          title: 'Description',
                          opacity: .5,
                        ),
                        AutoSizeText(
                          widget.board.description,
                          minFontSize: 16,
                          maxFontSize: 16,
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
