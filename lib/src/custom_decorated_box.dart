import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DecoratedBoxX extends SingleChildRenderObjectWidget {
  /// Creates a widget that paints a [Decoration].
  ///
  /// The [decoration] and [position] arguments must not be null. By default the
  /// decoration paints behind the child.
  const DecoratedBoxX({
    super.key,
    required this.decoration,
    this.position = DecorationPosition.background,
    super.child,
  });

  /// What decoration to paint.
  ///
  /// Commonly a [BoxDecoration].
  final Decoration decoration;

  /// Whether to paint the box decoration behind or in front of the child.
  final DecorationPosition position;

  @override
  RenderDecoratedBoxX createRenderObject(BuildContext context) {
    return RenderDecoratedBoxX(
      decoration: decoration,
      position: position,
      configuration: createLocalImageConfiguration(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderDecoratedBoxX renderObject) {
    // final layer = context.findAncestorRenderObjectOfType<RenderShaderMask>()?.layer;
    // print(layer);
    renderObject
      ..decoration = decoration
      ..configuration = createLocalImageConfiguration(context)
      ..position = position;
  }
}

class RenderDecoratedBoxX extends RenderProxyBox {
  /// Creates a decorated box.
  ///
  /// The [decoration], [position], and [configuration] arguments must not be
  /// null. By default the decoration paints behind the child.
  ///
  /// The [ImageConfiguration] will be passed to the decoration (with the size
  /// filled in) to let it resolve images.
  RenderDecoratedBoxX({
    required Decoration decoration,
    DecorationPosition position = DecorationPosition.background,
    ImageConfiguration configuration = ImageConfiguration.empty,
    RenderBox? child,
  })
      : _decoration = decoration,
        _position = position,
        _configuration = configuration,
        super(child);

  BoxPainter? _painter;

  /// What decoration to paint.
  ///
  /// Commonly a [BoxDecoration].
  Decoration get decoration => _decoration;
  Decoration _decoration;

  set decoration(Decoration value) {
    assert(value != null);
    if (value == _decoration) {
      return;
    }
    _painter?.dispose();
    _painter = null;
    _decoration = value;
    markNeedsPaint();
  }

  /// Whether to paint the box decoration behind or in front of the child.
  DecorationPosition get position => _position;
  DecorationPosition _position;

  set position(DecorationPosition value) {
    if (value == _position) {
      return;
    }
    _position = value;
    markNeedsPaint();
  }

  /// The settings to pass to the decoration when painting, so that it can
  /// resolve images appropriately. See [ImageProvider.resolve] and
  /// [BoxPainter.paint].
  ///
  /// The [ImageConfiguration.textDirection] field is also used by
  /// direction-sensitive [Decoration]s for painting and hit-testing.
  ImageConfiguration get configuration => _configuration;
  ImageConfiguration _configuration;

  set configuration(ImageConfiguration value) {
    if (value == _configuration) {
      return;
    }
    _configuration = value;
    markNeedsPaint();
  }

  @override
  void detach() {
    _painter?.dispose();
    _painter = null;
    super.detach();
    // Since we're disposing of our painter, we won't receive change
    // notifications. We mark ourselves as needing paint so that we will
    // resubscribe to change notifications. If we didn't do this, then, for
    // example, animated GIFs would stop animating when a DecoratedBox gets
    // moved around the tree due to GlobalKey reparenting.
    markNeedsPaint();
  }

  @override
  bool hitTestSelf(Offset position) {
    return _decoration.hitTest(size, position, textDirection: configuration.textDirection);
  }

  @override
  bool get isRepaintBoundary => true;
  final layerx = NoShaderLayer();
  @override
  void paint(PaintingContext context, Offset offset) {
    _painter ??= _decoration.createBoxPainter(markNeedsPaint);
    final ImageConfiguration filledConfiguration = configuration.copyWith(size: size);

    context.pushLayer(layerx, (context, offset) {
      if (position == DecorationPosition.background) {
        int? debugSaveCount;
        assert(() {
          debugSaveCount = context.canvas.getSaveCount();
          return true;
        }());


        _painter!.paint(context.canvas, offset, filledConfiguration);

        assert(() {
          if (debugSaveCount != context.canvas.getSaveCount()) {
            throw FlutterError.fromParts(<DiagnosticsNode>[
              ErrorSummary('${_decoration.runtimeType} painter had mismatching save and restore calls.'),
              ErrorDescription(
                'Before painting the decoration, the canvas save count was $debugSaveCount. '
                    'After painting it, the canvas save count was ${context.canvas.getSaveCount()}. '
                    'Every call to save() or saveLayer() must be matched by a call to restore().',
              ),
              DiagnosticsProperty<Decoration>('The decoration was', decoration,
                  style: DiagnosticsTreeStyle.errorProperty),
              DiagnosticsProperty<BoxPainter>('The painter was', _painter, style: DiagnosticsTreeStyle.errorProperty),
            ]);
          }
          return true;
        }());
        if (decoration.isComplex) {
          context.setIsComplexHint();
        }
      }
      super.paint(context, offset);
      if (position == DecorationPosition.foreground) {
        _painter!.paint(context.canvas, offset, filledConfiguration);
        if (decoration.isComplex) {
          context.setIsComplexHint();
        }
      }
    }, offset);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(_decoration.toDiagnosticsNode(name: 'decoration'));
    properties.add(DiagnosticsProperty<ImageConfiguration>('configuration', configuration));
  }
}

class NoShaderLayer extends ContainerLayer {

}