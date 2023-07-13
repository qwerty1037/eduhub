import 'package:flutter/material.dart';
import 'package:front_end/Component/Folder.dart';
import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:get/get.dart';

class DefaultTabBody extends StatelessWidget {
  const DefaultTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    FolderController controller = Get.find<FolderController>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: FolderTreeView(controller),
        ),
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.teal,
          ),
        )
      ],
    );
  }
}
