import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/task/store/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Buttons extends StatefulWidget {
  final bool isDone;
  final String id;
  final Task task;
  const Buttons(
      {super.key, required this.isDone, required this.id, required this.task});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  final TaskServiceImpl taskService = TaskServiceImpl();

  @override
  void didChangeDependencies() {
    context.watch<TaskStoreLocal>().isDoneTask = widget.isDone;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final TaskStoreLocal taskStoreLocal = context.watch<TaskStoreLocal>();
    print(taskStoreLocal.isEdit);
    return Observer(builder: (_) {
      return Column(
        children: [
          if (!taskStoreLocal.isDoneTask && !taskStoreLocal.isEdit)
            AnimatedToggleSwitch.rolling(
              current: widget.isDone,
              spacing: double.infinity,
              borderWidth: 0,
              height: 70,
              indicatorSize: const Size.fromWidth(70),
              values: const [false, true],
              style: ToggleStyle(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                indicatorColor: Theme.of(context).primaryColor,
              ),
              iconBuilder: (value, index) => widget.isDone == value
                  ? const Icon(Icons.done, color: Colors.black, size: 40)
                  : const DNText(
                      title: 'Done',
                      color: Colors.white,
                    ),
              iconsTappable: false,
              onChanged: (_) {
                taskService.changeDone(widget.id, !widget.isDone);
                setState(() {
                  taskStoreLocal.isDoneTask = true;
                });
              },
            ),
          if (taskStoreLocal.isEdit)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      setState(() => taskStoreLocal.isEdit = false),
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.red.shade400),
                      fixedSize: const WidgetStatePropertyAll(
                          Size(double.infinity, 50))),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DNText(
                        title: 'Cancel',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () =>
                      setState(() => taskStoreLocal.isEdit = false),
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.green),
                      fixedSize:
                          WidgetStatePropertyAll(Size(double.infinity, 50))),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DNText(
                        title: 'Save',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          if (taskStoreLocal.isDoneTask && !taskStoreLocal.isEdit)
            DNButton(
              width: 200,
              title: 'Cancel Is Done',
              onClick: () {
                taskService.changeDone(widget.id, !widget.isDone);
                setState(() {
                  taskStoreLocal.isDoneTask = false;
                });
              },
              isPrimary: false,
              color: Colors.red,
            )
        ],
      );
    });
  }
}
