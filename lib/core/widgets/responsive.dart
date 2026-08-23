import 'package:flutter/material.dart';

/// 响应式布局工具类,用于 iPad / 大屏适配
class Responsive {
  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 1024;

  /// iPad 等大屏内容最大宽度,超出后居中显示
  static const double maxContentWidth = 720;

  /// 阅读类页面最大宽度(阅读体验更佳)
  static const double maxReadingWidth = 680;

  /// 是否为平板(iPad)宽度
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  /// 是否为桌面宽度
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktopBreakpoint;

  /// 自适应列数:手机 1 列,iPad 2 列,桌面 3 列
  static int gridColumns(
    BuildContext context, {
    int phone = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= desktopBreakpoint) return desktop;
    if (width >= tabletBreakpoint) return tablet;
    return phone;
  }
}

/// 限制内容最大宽度,在 iPad / 大屏上居中显示,避免内容被无限拉伸
class ContentContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double? maxWidth;
  final Alignment alignment;

  const ContentContainer({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.maxWidth = Responsive.maxContentWidth,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth!),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
