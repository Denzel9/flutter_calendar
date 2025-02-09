import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/ui/components/animate/slide.dart';
import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/task/store/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Buttons extends StatefulWidget {
  final bool isDone;
  final String id;
  const Buttons({
    super.key,
    required this.isDone,
    required this.id,
  });

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  final TaskServiceImpl taskService = TaskServiceImpl(firestore);

  @override
  void didChangeDependencies() {
    context.watch<TaskStoreLocal>().isDoneTask = widget.isDone;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final TaskStoreLocal taskStoreLocal = context.watch<TaskStoreLocal>();

    return Observer(builder: (_) {
      return SlideAnimation(
        begin: const Offset(0, 2),
        widget: Column(
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
                  DNButton(
                    onClick: () =>
                        setState(() => taskStoreLocal.isEdit = false),
                    title: 'Save',
                    isPrimary: false,
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
        ),
      );
    });
  }
}
