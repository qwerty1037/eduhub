import 'package:front_end/Controller/Folder_Controller.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  RxBool isFolderEmpty = false.obs;
  FolderController folderController = Get.find<FolderController>();
  HomeScreenController() {
    if (folderController.firstFolders.isEmpty) {
      isFolderEmpty.value = true;
    }
  }
}
