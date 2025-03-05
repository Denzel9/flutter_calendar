import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/store/image_store/image_store.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/board/store/board.dart';
import 'package:calendar_flutter/ui/views/board/ui/action_buttons/add_action_button.dart';
import 'package:calendar_flutter/ui/views/board/ui/action_buttons/delete_action_button.dart';
import 'package:calendar_flutter/ui/views/board/ui/tabs/content.dart';
import 'package:calendar_flutter/ui/views/board/ui/information.dart';
import 'package:calendar_flutter/ui/views/create/ui/attachments.dart';
import 'package:calendar_flutter/utils/filter_tasks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum SampleItem { delete, active, done }

List<String> tabs = ['Tasks', 'Links', 'Attachments', 'Other'];

class BoardPage extends StatefulWidget {
  final String id;
  final String board;

  const BoardPage({
    super.key,
    required this.id,
    required this.board,
  });

  @override
  State<BoardPage> createState() => _BoardViewStatePage();
}

class _BoardViewStatePage extends State<BoardPage>
    with SingleTickerProviderStateMixin {
  late final tabController =
      TabController(length: 4, vsync: this, initialIndex: 0);
  late Stream<DocumentSnapshot<Map<String, dynamic>>> getBoard;
  late final BoardStoreLocal boardStoreLocal;
  late final ImageStore imageStore;

  @override
  void initState() {
    getBoard = boardService.getBoard(widget.id);
    super.initState();
  }

  Future<void> getImages() async {
    final List<ImageData> tempImages = [];
    for (final task in boardStoreLocal.tasks) {
      await taskService.getAttachments(task.docId ?? '').then((value) {
        for (var element in value) {
          tempImages.add(ImageData(task.docId ?? '', element));
        }
      });
    }
    imageStore.stringImages = tempImages;
  }

  @override
  void didChangeDependencies() {
    boardStoreLocal = BoardStoreLocal();
    final AppStore store = context.watch<AppStore>();
    imageStore = context.watch<ImageStore>();

    boardStoreLocal.tasks = filteredTaskToBoard(widget.board, store);

    getImages();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(boardStoreLocal.deletingList);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: StreamBuilder(
          stream: getBoard,
          builder: (context, snapshot) {
            final Board board = Board.fromJsonWithId(
                snapshot.data?.data(), snapshot.data?.id ?? '');
            return Provider(
              create: (context) => boardStoreLocal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: NestedScrollView(
                  headerSliverBuilder: (context, _) => [
                    Information(board: board),
                  ],
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        dividerHeight: 0,
                        onTap: (_) => setState(() {}),
                        controller: tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: Colors.amberAccent,
                        unselectedLabelColor: Colors.white54,
                        labelColor: Colors.amberAccent,
                        overlayColor: WidgetStateProperty.all(
                          Colors.amberAccent.withAlpha((0.1 * 255).toInt()),
                        ),
                        tabs: List.generate(
                          tabs.length,
                          (index) => Tab(
                            height: 50,
                            child: DNText(
                              title: tabs[index],
                              fontSize: 18,
                              color: tabController.index == index
                                  ? Colors.amberAccent
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            Content(title: board.title),
                            const SizedBox(),
                            Attachments(
                              voidCallback: getImages,
                              isDeleting: boardStoreLocal.isDeleting,
                              deleteCallback: () => setState(() {
                                boardStoreLocal.isDeleting = true;
                              }),
                              addToDelete: (ImageData image) => setState(() {
                                boardStoreLocal.deletingList.add(image);
                              }),
                              deleteList: boardStoreLocal.deletingList
                                  .map((el) => el.id)
                                  .toList(),
                            ),
                            const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: boardStoreLocal.isDeleting
          ? DeleteActionButton(
              tabController: tabController,
              board: widget.board,
              voidCallback: getImages,
            )
          : AddActionButton(
              tabController: tabController,
              board: widget.board,
              voidCallback: getImages,
            ),
    );
  }
}
