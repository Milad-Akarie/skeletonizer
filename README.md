<p align="center">                    
<img  src="https://raw.githubusercontent.com/Milad-Akarie/skeletonizer/main/art/skeletonizer_logo.svg" height="130">                    
</p>                    

<p align="center">                    
<a href="https://img.shields.io/badge/License-MIT-green"><img src="https://img.shields.io/badge/License-MIT-green" alt="MIT License"></a>                    
<a href="https://github.com/Milad-Akarie/skeletonizer/stargazers"><img src="https://img.shields.io/github/stars/Milad-Akarie/skeletonizer?style=flat&logo=github&colorB=green&label=stars" alt="stars"></a>                    
<a href="https://pub.dev/packages/skeletonizer"><img src="https://img.shields.io/pub/v/skeletonizer.svg?label=pub&color=orange" alt="pub version"></a>                    
</p>                    

<p align="center">                  
<a href="https://www.buymeacoffee.com/miladakarie" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="30px" width= "108px"></a>                  
</p>                  
---

- [Introduction](#introduction)
- [Basic usage](#basic-usage)
- [Annotations](#annotations)
- [Customization](#customization)

## Introduction
### What are skeleton loaders?
Skeleton loaders are visual placeholders for information while data is still loading. Anatomy. A skeleton loader provides a low fidelity representation of the interface that will be loaded.

### Motivation
Creating a skeleton-layout for your screens doesn't only feel like a duplicate work but things can go out of synce real quick, when updating the actual layout we often forget to update the corrosponding skelton-layout.


### How does it work?
As the name suggests, skeletonizer will reduce your already existing layouts into mere skeletons and apply painting effects on them, typically a shimmer effect. It automatically does the job for you, in addention SkeletonAnnotations can be used to change how some widgets are skeletonized.


## Basic usage
Simply wrap your layout with `Skeletonizer` widget

```dart
 Skeletonizer(
    enabled: _loading,
    child: ListView.builder(
      itemCount: 7,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text('Item number $index as title'),
            subtitle: const Text('Subtitle here'),
            trailing: const Icon(Icons.ac_unit),
          ),
        );
      },
    ),
  )
```
**Note: all the following shimmer effects are distured by the gif optimization**

#### Skeletonizer with default config

![](https://github.com/Milad-Akarie/skeletonizer/blob/main/art/skeletonizer_demo_1.gif?raw=true)

#### Skeletonizer with no containers
```dart
Skeletonizer(ignoreContainers: true)
```
![](https://github.com/Milad-Akarie/skeletonizer/blob/main/art/skeletonizer_demo_2.gif?raw=true)


## Annotations
We can use annotations to change how some widgets should be skeletonized, skeleton annotations have no effect on the real layout as they're only hold information for skeletonizer to use when it's enabled.


### Skeleton.ignore
Widgets annotated with `Skeleton.ignore` will not be skeletonized

```dart
  Card(
      child: ListTile(
        title: Text('The title goes here'),
        subtitle: Text('Subtitle here'),
        trailing: Skeleton.ignore( // the icon will not be skeletonized
          child: Icon(Icons.ac_unit, size: 40),
        ),
      ),
    )
```
![](https://github.com/Milad-Akarie/skeletonizer/blob/main/art/ignored_skeleton_demo.gif?raw=true)
**Ignored mulitple descenedets dmoe**
```dart
  Card(
      child: Skeleton.ignore( // all descenets will be ignored
        child: ListTile(
          title: Text('The title goes here'),
          subtitle: Text('Subtitle here'),
          trailing: Icon(Icons.ac_unit, size: 40),
        ),
      ),
    )
```
![](https://github.com/Milad-Akarie/skeletonizer/blob/main/art/ignored_skeleton_demo2.gif?raw=true)



### Skeleton.keep
Widgets annotated with `Skeleton.keep` will not be skeletonized but will be painted as is

```dart
  Card(
      child: ListTile(
        title: Text('The title goes here'),
        subtitle: Text('Subtitle here'),
        trailing: Skeleton.keep( // the icon will be painted as is
          child: Icon(Icons.ac_unit, size: 40),
        ),
      ),
    )
```
![](https://github.com/Milad-Akarie/skeletonizer/blob/main/art/kept_skeleton_demo.gif?raw=true)

### Skeleton.shade
Widgets annotated with `Skeleton.shade` will not be skeletonized but will be shaded by a shader mask

```dart
  Card(
      child: ListTile(
        title: Text('The title goes here'),
        subtitle: Text('Subtitle here'),
        trailing: Skeleton.shade( // the icon will be shaded by shader mask
          child: Icon(Icons.ac_unit, size: 40),
        ),
      ),
    )
```
![](https://github.com/Milad-Akarie/skeletonizer/blob/main/art/shaded_skeleton_demo.gif?raw=true)

### Skeleton.replace
Widgets annotated with `Skeleton.replace` will be replaced when skeleontizer is enabled and the replacment will be skeleontized, This is good for widgets that can render with fake data like `Image.network()`

```dart
  Card(
      child: ListTile(
        title: Text('The title goes here'),
        subtitle: Text('Subtitle here'),
        trailing: Skeleton.replace( // the icon will be replaced when skeletonizer is on
           width: 50, // the width of the replacment
           height: 50, // the hight of the replacment
           replacment: // defualts to a DecortedBox
          child: Icon(Icons.ac_unit, size: 40),
        ),
      ),
    )
```
![](https://github.com/Milad-Akarie/skeletonizer/blob/main/art/replaced_skeleton_demo.gif?raw=true)

### Skeleton.unite
Widgets annotated with `Skeleton.unite` will not be united and drawn as one big bone, this is good for whne you have mulitple small bones close to each other and you want to present them as one bone.

```dart
Card(
  child: ListTile(
    title: Text('Item number 1 as title'),
    subtitle: Text('Subtitle here'),
    trailing: Skeleton.unite(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.ac_unit, size: 32),
          SizedBox(width: 8),
          Icon(Icons.access_alarm, size: 32),
        ],
      ),
    ),
  ),
),
```
![](https://github.com/Milad-Akarie/skeletonizer/blob/main/art/united_skeleton_demo.gif?raw=true)

This annotation can also be used to merge a while layout and presenet it as one
```dart
  Skeleton.unite(
      child: Card(
        child: ListTile(
          title: Text('Item number 1 as title'),
          subtitle: Text('Subtitle here'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.ac_unit, size: 32),
              SizedBox(width: 8),
              Icon(Icons.access_alarm, size: 32),
            ],
          ),
        ),
      ),
    )
```
![](https://github.com/Milad-Akarie/skeletonizer/blob/main/art/united_skeleton_demo2.gif?raw=true)
### Support Skeletonizer
You can support skeletonizer by liking it on Pub and staring it on Github, sharing ideas on how we can enhance a certain functionality or by reporting any problems you encounter and of course buying a couple coffees will help speed up the development process.