class BoneConfig {
  final bool includeBone;

  const BoneConfig({this.includeBone = true});
}

class BoxBoneConfig extends BoneConfig {
  final bool treatAsBone;
  final bool canBeContainer;

  BoxBoneConfig({
    this.treatAsBone = false,
    this.canBeContainer = false,
    super.includeBone,
  });

  BoxBoneConfig copyWith({
    bool? treatAsBone,
    bool? includeBone,
    bool? canBeContainer,
  }) {
    return BoxBoneConfig(
      treatAsBone: treatAsBone ?? this.treatAsBone,
      includeBone: includeBone ?? this.includeBone,
      canBeContainer: canBeContainer ?? this.canBeContainer,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoxBoneConfig &&
          runtimeType == other.runtimeType &&
          includeBone == other.includeBone &&
          canBeContainer == other.canBeContainer &&
          treatAsBone == other.treatAsBone;

  @override
  int get hashCode => treatAsBone.hashCode ^ includeBone.hashCode ^ canBeContainer.hashCode;
}

class TextBoneConfig extends BoneConfig {
  final double radius;
  final double width;
  final double indent;
  final bool fixedWidth;
  final bool canHaveFixedWidth;

  const TextBoneConfig({
    this.radius = 0,
    this.width = 0,
    this.indent = 0,
    this.fixedWidth = false,
    this.canHaveFixedWidth = false,
    super.includeBone,
  });

  TextBoneConfig copyWith({
    double? radius,
    double? width,
    double? indent,
    bool? fixedWidth,
    bool? canHaveFixedWidth,
    bool? includeBone,
  }) {
    return TextBoneConfig(
      radius: radius ?? this.radius,
      width: width ?? this.width,
      indent: indent ?? this.indent,
      fixedWidth: fixedWidth ?? this.fixedWidth,
      canHaveFixedWidth: canHaveFixedWidth ?? this.canHaveFixedWidth,
      includeBone: includeBone ?? this.includeBone,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextBoneConfig &&
          runtimeType == other.runtimeType &&
          radius == other.radius &&
          width == other.width &&
          indent == other.indent &&
          fixedWidth == other.fixedWidth &&
          includeBone == other.includeBone &&
          canHaveFixedWidth == other.canHaveFixedWidth;

  @override
  int get hashCode =>
      radius.hashCode ^
      width.hashCode ^
      indent.hashCode ^
      fixedWidth.hashCode ^
      canHaveFixedWidth.hashCode ^
      includeBone.hashCode;
}
