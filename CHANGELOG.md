## 2.0.0-pre
- chore: support flutter 3.31.0.pre+
## 1.4.3
- feat: expose AnimatedSwitcher.layoutBuilder
## 1.4.2
- pass static analysis
- change the default colors of PulseEffect
## 1.4.1+1 (no changes)
- update README.md
## 1.4.1
- deprecated SkeletonizerConfigData.light constructor  in favor of default constructor
## 1.4.0
- Feat: SkeletonizerConfigData can now be used as Theme.extension to provide default configuration
  values for Skeletonizer widgets. by @waadsulaiman
## 1.3.0
- Feat: add switch animation option to animate the transition between skeleton and content
## 1.2.0
- Feat: allow nested Skeletonizer widgets
## 1.1.2+1
- Fix pub.dev preview image
## 1.1.2
- Fix Skeleton.leaf has no effect on android devices #30
## 1.1.1
- Chore: satisfy static analysis
- throw an elaborative error message when nesting Skeletonizer widgets.
## 1.1.0
- Rename Skeletonizer.bones to Skeletonizer.zone because it makes more sense
  Enhance Skeletonizer.zone implementation to be more optimized
  Add BoneMock to easily generate fake text
## 1.0.1 
- Fix null check exception when nesting Skeletonizers #15
## 1.0.0 [Hooray!]

- Add an intuitive way to build custom skeletons using `Skeletononizer.bones' constructor and Bone
  widgets.

## 0.9.0

- Enhance text skeletonizing implementation, which also fixes #16 (SelectableText not being
  skeletonized).

## 0.8.0

- Fix: Skeletonized widgets are not clipped inside of expandable parents.
- refactor: clean up some code

## 0.7.0

- Fix: in some cases skeleton is drawn out of clip-bounds
- Refactor: clean up internal API and remove some unnecessary properties

## 0.6.0

- Add RTL Support
- Use own layer to paint instead of RenderObject.layer

## 0.5.0

- Add Skeleton.leaf annotation to mark container widgets as leaf widget so they can be painted with
  shader paint.
- Handle mis-positioned painting of RenderLeaderLayer children.

## 0.4.0

- refactor: remove Skeleton.coloredBox because they're now handled automatically by
  skeletonizer. [Breaking Change]
- enhance: Skeletonizer now overrides the painting context instead of iterating over render objects
  which makes it much preformat.

## 0.3.0 [Breaking Change]

- Fix crash when running in release mode.
- ColoredBox and Container with non-null color will need now need to be exclusively wrapped with a
  Skeleton.coloredBox annotation widget due to platform limitations.

## 0.2.0

- Add SliverSkeletonizer and Skeletonizer.sliver to handle sliver widgets.

## 0.1.2

- improve docs

## 0.1.1

- Fix containers with no descendants should not be ignored
- Add tutorial article link to documentation

## 0.1.0+2

- fix docs formatting.
- ## 0.1.0+1
- add docs.

## 0.1.0

- initial release.