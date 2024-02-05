import 'package:flutter/services.dart';
import 'package:front_end/Component/Default/default_text_box.dart';
import 'package:front_end/Controller/search_controller.dart';
import 'dart:ui';
import 'package:front_end/Controller/fluent_tab_controller.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// Create Overlay of SearchBar
void createHighlightOverlay({
  required BuildContext context,
  required SearchScreenController controller,
  required FluentTabController tabController,
}) {
  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry? overlayEntry;
  FocusNode fc = FocusNode();
  overlayEntry = OverlayEntry(
    // Create a new OverlayEntry.
    builder: (BuildContext context) {
      // Align is used to position the highlight overlay
      // relative to the NavigationBar destination.
      return RawKeyboardListener(
        focusNode: fc,
        autofocus: true,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
            if (event is RawKeyDownEvent) {
              controller.searchBarController.text = "";

              overlayEntry?.remove();
            }
          }
        },
        child: Stack(
          children: [
            ModalBarrier(
              onDismiss: () {
                controller.searchBarController.text = "";
                overlayEntry?.remove();
              },
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.1,
              top: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.1,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2,
                  sigmaY: 2,
                ),
                child: DefaultTextBox(
                  controller: controller.searchBarController,
                  placeholder: "SearchBar",
                  prefix: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Icon(FluentIcons.search),
                  ),
                  suffix: const Icon(FluentIcons.chevron_right),
                  onChanged: (value) => controller.searchBarController.text,
                  onEditingComplete: () {
                    //홈화면에서 눌렀을때
                    if (tabController.currentTabIndex.value == 0) {
                      controller.searchBarController.text = "";
                      overlayEntry?.remove();
                      displayInfoBar(context, builder: (context, close) {
                        return InfoBar(
                          title: const Text("검색기능:"),
                          content: const Text("준비중인 서비스 입니다"),
                          action: IconButton(
                            icon: const Icon(FluentIcons.clear),
                            onPressed: close,
                          ),
                          severity: InfoBarSeverity.warning,
                        );
                      });
                    } else {
                      controller.searchBarController.text = "";
                      overlayEntry?.remove();
                      displayInfoBar(context, builder: (context, close) {
                        return InfoBar(
                          title: const Text("검색기능:"),
                          content: const Text("준비중인 서비스 입니다"),
                          action: IconButton(
                            icon: const Icon(FluentIcons.clear),
                            onPressed: close,
                          ),
                          severity: InfoBarSeverity.warning,
                        );
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
  overlayState.insert(overlayEntry);
  // Add the OverlayEntry to the Overlay.
  // Overlay.of(context, debugRequiredFor: widget).insert(overlayEntry!);
}
