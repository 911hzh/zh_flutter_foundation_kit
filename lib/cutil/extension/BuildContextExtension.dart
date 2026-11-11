/// BuildContext 相关扩展。
///
/// 提供从上下文读取渲染信息的快捷能力。
import "package:flutter/cupertino.dart";

/// [BuildContext] 扩展方法。
extension BuildContextExtension on BuildContext {
  /// 当前 context 对应渲染对象的尺寸。
  Size? get renderSize {
    RenderBox? renderBox = findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return null;
    }
    Size size = renderBox.size;
    return size;
  }
}
