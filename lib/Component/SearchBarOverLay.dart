import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_end/Component/DefaultTextBox.dart';
import 'package:front_end/Screen/Default_Tab_Body.dart';
import 'package:front_end/Screen/SearchScreen.dart';
import 'dart:ui';
import 'package:front_end/Controller/tab.controller.dart' as t;
import 'package:fluent_ui/fluent_ui.dart' as f;

void createHighlightOverlay({
  required BuildContext context,
  required controller,
  required t.TabController tabController,
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
                    child: Icon(Icons.search),
                  ),
                  suffix: const Icon(Icons.arrow_forward_ios),
                  onChanged: (value) => controller.searchBarController.text,
                  onEditingComplete: () {
                    tabController.isHomeScreen.value = false;
                    DefaultTabBody tabBody = DefaultTabBody(workingSpace: SearchScreen());
                    f.Tab newTab = tabController.addTab(tabBody, "SearchScreen");
                    tabController.tabs.add(newTab);
                    tabController.currentTabIndex.value = tabController.tabs.length - 1;
                    controller.searchBarController.text = "";
                    overlayEntry?.remove();
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
