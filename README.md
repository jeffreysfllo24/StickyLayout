# StickyLayout

<img src="https://travis-ci.org/jeffreysfllo24/StickyLayout.svg?branch=master">

[![codecov](https://codecov.io/gh/jeffreysfllo24/StickyLayout/branch/master/graph/badge.svg)](https://codecov.io/gh/jeffreysfllo24/StickyLayout)

## What is StickyLayout?
**StickyLayout** is a collection view layout that provides sticky row and column configurability.

## Features

- [X] Pure Swift 5.
- [X] Horizontal and vertical scrolling support.
- [X] Configurable Sticky options.
- [X] Works with every `UICollectionView`.

## Setup
Using **StickyLayout** quick and simple. First import `StickyLayout`. You then have the option of creating an instance of `StickyConfig`, where you can specify which rows/columns you want to be sticky. Create an instance of `StickyLayout` with your `StickyConfig` as a parameter, and add it to your `UICollectionView`.

```swift
import StickyLayout
```
```swift
let stickyConfig = StickyLayoutConfig(stickyRowsFromTop: 1,
                                stickyRowsFromBottom: 0,
                                stickyColsFromLeft: 1,
                                stickyColsFromRight: 0)

let layout = StickyLayout(stickyConfig: stickyConfig)
```
```swift
UICollectionView(frame: .zero, collectionViewLayout: layout)
```

## Installation
BouncyLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "StickyLayout"
```
