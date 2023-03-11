import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'request_headers.dart';
import 'request_params.dart';
import 'request_body.dart';

class EditRequestPane extends ConsumerStatefulWidget {
  const EditRequestPane({super.key});

  @override
  ConsumerState<EditRequestPane> createState() => _EditRequestPaneState();
}

class _EditRequestPaneState extends ConsumerState<EditRequestPane>
    with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 3,
      animationDuration: tabAnimationDuration,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    _controller.index = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(activeId!)
        .requestTabIndex;
    return Column(
      children: [
        TabBar(
          key: Key(activeId),
          controller: _controller,
          overlayColor: colorTransparent,
          onTap: (index) {
            ref
                .read(collectionStateNotifierProvider.notifier)
                .update(activeId, requestTabIndex: _controller.index);
          },
          tabs: const [
            SizedBox(
              height: kTabHeight,
              child: Center(
                child: Text(
                  'URL Params',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: textStyleButton,
                ),
              ),
            ),
            SizedBox(
              height: kTabHeight,
              child: Center(
                child: Text(
                  'Headers',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: textStyleButton,
                ),
              ),
            ),
            SizedBox(
              height: kTabHeight,
              child: Center(
                child: Text(
                  'Body',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: textStyleButton,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              EditRequestURLParams(),
              EditRequestHeaders(),
              EditRequestBody(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
