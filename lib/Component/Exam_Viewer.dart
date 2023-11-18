import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/Controller/ScreenController/Default_Tab_Body_Controller.dart';
import 'package:front_end/Controller/Tab_Controller.dart' as t;
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ExamViewer extends StatelessWidget {
  ExamViewer({
    super.key,
    required this.examPdfFile,
  });
  final DefaultTabBodyController _defaultTabBodyController = Get.find<DefaultTabBodyController>(tag: Get.find<t.TabController>().getTabKey());

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
              Row(
                children: [
                  const Icon(FluentIcons.pdf),
                  FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      "pdf name",
                      style: const TextStyle(
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
          child: Text("examPdf"),
        ),
      ],
      //SfPdfViewer.file(examPdfFile),
    );
  }
}
