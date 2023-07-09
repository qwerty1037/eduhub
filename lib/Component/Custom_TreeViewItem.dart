import 'package:fluent_ui/fluent_ui.dart';

class DraggableTreeViewItem extends TreeViewItem {
  @override
  final Widget content;
  @override
  final dynamic value;

  DraggableTreeViewItem({
    required this.content,
    this.value,
    List<TreeViewItem> children = const [],
    bool collapsable = true,
    bool expanded = true,
    bool? selected = false,
    Future<void> Function(TreeViewItem, TreeViewItemInvokeReason)? onInvoked,
    Future<void> Function(TreeViewItem, bool)? onExpandToggle,
    Map<Type, GestureRecognizerFactory> gestures = const {},
    ButtonState<Color>? backgroundColor,
    bool autofocus = false,
    FocusNode? focusNode,
    String? semanticLabel,
    Widget? loadingWidget,
    bool lazy = false,
  }) : super(
          content: content,
          value: value,
          children: children,
          collapsable: collapsable,
          expanded: expanded,
          selected: selected,
          onInvoked: onInvoked,
          onExpandToggle: onExpandToggle,
          gestures: gestures,
          backgroundColor: backgroundColor,
          autofocus: autofocus,
          focusNode: focusNode,
          semanticLabel: semanticLabel,
          loadingWidget: loadingWidget,
          lazy: lazy,
        );

  @override
  Widget build(BuildContext context) {
    return Draggable<TreeViewItem>(
      data: this,
      feedback: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: content,
        ),
      ),
      childWhenDragging: Container(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: leading,
          title: content,
        ),
      ),
    );
  }
}
