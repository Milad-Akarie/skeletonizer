import 'package:flutter/widgets.dart';

extension PaddingX on EdgeInsetsGeometry {
  String get describe {
    if (this is EdgeInsetsDirectional) {
      final String constructor;
      final p = this as EdgeInsetsDirectional;
      if (p.start == p.end && p.end == p.top && p.top == p.bottom) {
        constructor = 'all(${p.start.describe})';
      } else if (p.start == p.end && p.bottom == p.top) {
        constructor = 'symmetric(${[
          if (p.vertical != 0) 'vertical: ${p.vertical.describe}',
          if (p.horizontal != 0) 'horizontal: ${p.horizontal.describe}'
        ].join(',')})';
      } else if ([p.start, p.end, p.bottom, p.top].any((e) => e == 0)) {
        constructor = 'only(${[
          if (p.start != 0) 'start: ${p.start.describe}',
          if (p.top != 0) 'top: ${p.top.describe}',
          if (p.end != 0) 'end: ${p.end.describe}',
          if (p.bottom != 0) 'bottom: ${p.bottom.describe}',
        ].join(',')})';
      } else {
        constructor = 'fromSTEB(${p.start.describe},${p.top.describe},${p.end.describe},${p.bottom.describe},)';
      }
      return 'EdgeInsetsDirectional.$constructor';
    } else {
      final String constructor;
      final p = this as EdgeInsets;
      if (p.left == p.right && p.right == p.top && p.top == p.bottom) {
        constructor = 'all(${p.left.describe})';
      } else if (p.left == p.right && p.bottom == p.top) {
        constructor = 'symmetric(${[
          if (p.vertical != 0) 'vertical: ${p.vertical.describe}',
          if (p.horizontal != 0) 'horizontal: ${p.horizontal.describe}'
        ].join(',')})';
      } else if ([p.left, p.right, p.bottom, p.top].any((e) => e == 0)) {
        constructor = 'only(${[
          if (p.left != 0) 'left: ${p.left.describe}',
          if (p.top != 0) 'top: ${p.top.describe}',
          if (p.right != 0) 'right: ${p.right.describe}',
          if (p.bottom != 0) 'bottom: ${p.bottom.describe}',
        ].join(',')})';
      } else {
        constructor = 'fromLTRB(${p.left.describe},${p.top.describe},${p.right.describe},${p.bottom.describe},)';
      }
      return 'EdgeInsets.$constructor';
    }
  }
}

extension OffestX on Offset {
  String get describe {
    if (dx == 0 && dy == 0) {
      return 'Offset.zero';
    }
    return 'Offset(${dx.describe},${dy.describe})';
  }
}

extension BorderRadiusGeometryX on BorderRadiusGeometry {
  String get describe {
    return toString();
  }
}

extension NumX on num {
  String get describe => isInfinite
      ? 'double.infinity'
      : (this - toInt() == 0)
          ? toStringAsFixed(0)
          : toString();
}

extension AxisX on Axis {
  String get widgetName => this == Axis.vertical ? 'Column' : 'Row';
}
