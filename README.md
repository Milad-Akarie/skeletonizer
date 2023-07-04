<br/>
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
- [The need for fake data](#the-need-for-fake-data)
- [Annotations](#annotations)
- [Customization](#customization)
- [Resources](#resources)

## Introduction

### What are skeleton loaders?

UI skeleton loading is a technique used to enhance user experience during web or app loading. It involves displaying a simplified, static version of the user interface while the actual content is being fetched. This placeholder UI gives the illusion of instant loading and prevents users from perceiving long loading times.

### Motivation

Creating a skeleton-layout for your screens doesn't only feel like a duplicate work but things can
go out of sync real quick, when updating the actual layout we often forget to update the
corresponding skeleton-layout.

### How does it work?

As the name suggests, skeletonizer will reduce your already existing layouts into mere skeletons and
apply painting effects on them, typically a shimmer effect. It automatically does the job for you,
in addition skeleton annotations can be used to change how specific widgets are skeletonized.

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

**Note: all the following shimmer effects are disturbed by the gif optimization**

#### Skeletonizer with default config

![](https://github.com/Milad-Akarie/skeletonizer/blob/main/art/skeletonizer_demo_1.gif?raw=true)

#### Skeletonizer with no containers

```dart

Skeletonizer(ignoreContainers: true)
```

![](https://github.com/Milad-Akarie/skeletonizer/blob/main/art/skeletonizer_demo_2.gif?raw=true)

## The need for fake data

In order for skeletonizer to work it actually needs a layout, but in most cases the layout would
need data to shape, e.g the following ListView ill not render anything unless `users` is populated, because if users is empty
we have no layout which means we have nothing to skeletonize.

```dart
Skeletonizer(
  enabled: _loading,
  child: ListView.builder(
    itemCount: users.lenght,
    itemBuilder: (context, index) {
      return Card(
        child: ListTile(
          title: Text(users[index].name),
          subtitle: Text(users[index].jobTitle),
          leading: CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(users[index].avatar),
          ),
        ),
      );
    },
  ),
)
```

So the key here is to provide fake data for the layout to shape until the real data is fetched form
the server, and we would have such a setup in our build method:

```dart
 
  if (_loading) {
    final fakeUsers = List.generate(
      7, (index) => const User(
        name: 'User name',
        jobTitle: 'Developer',
        avatar: ''
    ),
    );
    return Skeletonizer(
      child: UserList(users: fakeUsers),
    );
  } else {
    return UserList(users: realUsers);
  }  

```

or by utilizing the `enabled` flag

```dart
  {
  final users = _loading ? List.generate(
      7, (index) => const User(
      name: 'User name',
      jobTitle: 'Developer',
      avatar: ''
  ) : realUsers;
  );
  return Skeletonizer(
    enabled: _loading,
    child: UserList(users: users),
  );
 
```

Now we have our layout but one issue remains, if you run the above example you'll get an error in
your console stating that an invalid url was passed to `NetworkImage` which is legit because our fake
avatar url is an empty string, in such cases we need to make sure NetworkImage is not in our widget
tree when skeletonizer is enabled and we do that by using a skeleton annotation
called `Skeleton.replace` ..read more about annotations below.

```dart
Skeletonizer(
  enabled: _loading,
  child: ListView.builder(
    itemCount: users.lenght,
    itemBuilder: (context, index) {
      return Card(
        child: ListTile(
          title: Text(users[index].name),
          subtitle: Text(users[index].jobTitle),
            leading: Skeleton.replace(
            width: 48, // width of replacement
            height: 48, // height of replacement
            child; CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(users[index].avatar),
          ),
        ),
      );
    },
  ),
)
```

or you can do it directly like follows:

```dart
Skeletonizer(
  enabled: _loading,
  child: ListView.builder(
    itemCount: users.lenght,
    itemBuilder: (context, index) {
      return Card(
        child: ListTile(
          title: Text(users[index].name),
          subtitle: Text(users[index].jobTitle),
            leading: CircleAvatar(
            radius: 24,
            backgroundImage: _loading ? null : NetworkImage(users[index].avatar),
          ),
        ),
      ),);
    },
  ),
)
```

**Note**: you can also check wither a skeletonizer is enabled inside descendent widgets using:

```dart
Skeletonizer.of(context).enabled;
```

## Annotations

We can use annotations to change how some widgets should be skeletonized, skeleton annotations have
no effect on the real layout as they only hold information for skeletonizer to use when it's
enabled.

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

Ignored multiple descendants demo

```dart
Card(
  child: Skeleton.ignore( // all descendents will be ignored
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

Widgets annotated with `Skeleton.replace` will be replaced when skeletonizer is enabled and the
replacement will be skeletonized, This is good for widgets that can not render with fake data
like `Image.network()`

```dart
Card(
  child: ListTile(
    title: Text('The title goes here'),
    subtitle: Text('Subtitle here'),
    trailing: Skeleton.replace( // the icon will be replaced when skeletonizer is enabled
        width: 50, // the width of the replacement
        height: 50, // the height of the replacement
        replacment: // defaults to a DecoratedBox
        child: Icon(Icons.ac_unit, size: 40),
  ),
)
,)
```

![](https://github.com/Milad-Akarie/skeletonizer/blob/main/art/replaced_skeleton_demo.gif?raw=true)

### Skeleton.unite
Widgets annotated with `Skeleton.unite` will not be united and drawn as one big bone, this is good
for when you have multiple small bones close to each other and you want to present them as one bone.

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
)
,
```

![](https://github.com/Milad-Akarie/skeletonizer/blob/main/art/united_skeleton_demo.gif?raw=true)

This annotation can also be used to merge a while layout and present it as one

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

## Customization

### Loading effects

Skeletonizer has 3 different painting effects to choose from which can be customized to your
liking.

**Note: Loading effects are disturbed by Gif optimization, these look much better on flutter**

![](https://github.com/Milad-Akarie/skeletonizer/blob/main/art/loading_effects_demo.gif?raw=true)

### Text skeleton config

You can provide a global text config options to skeletonizer widgets like

```dart
Skeletonizer(
    justifyMultiLineText: false,
    textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(.5),
    ...
)
```

![](https://github.com/Milad-Akarie/skeletonizer/blob/main/art/text_config_demo.gif?raw=true)

### Using the inheritable SkeletonizerConfig widget

Use `SkeletonizerConfig` somewhere up your widgets tree e.g above the `MaterialApp` widget to
provide
default skeletonizer configurations to your whole App.

```dart
SkeletonizerConfig(
    data: SkeletonizerConfigData(
      effect: const ShimmerEffect(),
      justifyMultiLineText: true,
      textBorderRadius: TextBoneBorderRadius(..),
      ignoreContainers: false,
    ),
    .....
)
```
## Resources
- [Flutter skeleton loader using skeletonizer](https://medium.com/@milad-akarie/flutter-skeleton-loader-using-skeletonizer-13d410dc4ac7)
 
### Support Skeletonizer

You can support skeletonizer by liking it on Pub and staring it on Github, sharing ideas on how we
can enhance a certain functionality or by reporting any problems you encounter and of course buying
a couple coffees will help speed up the development process.