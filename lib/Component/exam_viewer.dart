import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Controller/ScreenController/default_tab_body_controller.dart';
import 'package:front_end/Controller/fluent_tab_controller.dart';
import 'package:get/get.dart';

class ExamViewer extends StatelessWidget {
  ExamViewer({
    super.key,
    required this.examPdfFile,
  });
  final DefaultTabBodyController _defaultTabBodyController = Get.find<DefaultTabBodyController>(tag: Get.find<FluentTabController>().getTabKey());

  final examPdfFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 25,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.3,
            ),
          ),
          child: Stack(
            children: [
              const Row(
                children: [
                  Icon(FluentIcons.pdf),
                  FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      "pdf name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(
                    FluentIcons.chrome_close,
                  ),
                  onPressed: () {
                    _defaultTabBodyController.changeWorkingSpace(_defaultTabBodyController.savedWorkingSpace!);
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          child: const Text("examPdf"),
        ),
      ],
      //SfPdfViewer.file(examPdfFile),
    );
  }
}
