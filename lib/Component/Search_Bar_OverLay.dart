import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_end/Component/Default/Default_TextBox.dart';
import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
import 'package:front_end/Controller/Search_Controller.dart';
import 'package:front_end/Screen/Default_Tab_Body.dart';
import 'package:front_end/Screen/Search_Screen.dart';
import 'dart:ui';
import 'package:front_end/Controller/Tab_Controller.dart' as t;
import 'package:fluent_ui/fluent_ui.dart' as f;
import 'package:get/get.dart';

/// Create Overlay of SearchBar
void createHighlightOverlay({
  required BuildContext context,
  required SearchScreenController controller,
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
                    //홈화면에서 눌렀을때
                    if (tabController.currentTabIndex.value == -1) {
                      tabController.isNewTab = true;
                      tabController.isHomeScreen.value = false;
                      DefaultTabBody tabBody =
                          DefaultTabBody(workingSpace: SearchScreen());
                      f.Tab newTab =
                          tabController.addTab(tabBody, "SearchScreen");
                      tabController.tabs.add(newTab);
                      tabController.currentTabIndex.value =
                          tabController.tabs.length - 1;
                      controller.searchBarController.text = "";
                      overlayEntry?.remove();
                      tabController.isNewTab = false;
                    } else {
                      controller.searchBarController.text = "";
                      overlayEntry?.remove();
                      Get.find<DefaultTabBodyController>(
                              tag: tabController.getTabKey())
                          .deleteWorkingSpaceController();

                      Get.find<DefaultTabBodyController>(
                              tag: tabController.getTabKey())
                          .changeWorkingSpace(SearchScreen());

                      f.Tab currentTab = tabController
                          .tabs[tabController.currentTabIndex.value];
                      tabController.renameTab(currentTab, "SearchScreen");
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
