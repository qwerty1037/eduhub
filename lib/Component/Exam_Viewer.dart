import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ExamViewer extends StatelessWidget {
  const ExamViewer({
    super.key,
    required this.examPdfFile,
  });

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
                  onPressed: () {},
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
