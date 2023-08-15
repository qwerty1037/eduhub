import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_quill/flutter_quill.dart';

class EditorTest extends StatelessWidget {
  final QuillController controller = QuillController.basic();

  EditorTest({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Column(
        children: [
          QuillToolbar.basic(controller: controller),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            child: QuillEditor.basic(
              controller: controller,
              readOnly: false,
            ),
          ),
        ],
      ),
    );
  }
}
