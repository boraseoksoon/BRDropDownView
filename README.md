# BRDropDownView

[![CI Status](http://img.shields.io/travis/boraseoksoon@gmail.com/BRDropDownView.svg?style=flat)](https://travis-ci.org/boraseoksoon@gmail.com/BRDropDownView)
[![Version](https://img.shields.io/cocoapods/v/BRDropDownView.svg?style=flat)](http://cocoapods.org/pods/BRDropDownView)
[![License](https://img.shields.io/cocoapods/l/BRDropDownView.svg?style=flat)](http://cocoapods.org/pods/BRDropDownView)
[![Platform](https://img.shields.io/cocoapods/p/BRDropDownView.svg?style=flat)](http://cocoapods.org/pods/BRDropDownView)

BRDropDownView : "Observe Y offset of targetView, then DropDown and Up Custom UI View that supports various styles."

<br>
<img src="" width=240>
<img src="" width=240>
<br>

BRDropDownView is <b>BORING</b> DropDown && Up animated UIView Component that animates dropdown and up depending on Y offset of a View you want to observe, supporting various style of subview type.<br>

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS 9.0 + <br>
Swift 3.0 + <br>

## Installation

BRDropDownView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BRDropDownView'
```

## How to use
Since this is straightforwardly simple to use, you can get how to use BRDropDownView by chekcing ViewController.swift in example project.<br>

<b>Step 1. create BRDropDownView programmatically or via storyboard or xib.</b>
<br>

By doing so, You can not only create BRCountDown instance, but also customize properties including countdown animation on your own way.<br>
Check sample code below.<br>
* be careful that BRDropDownView is only supported for fixed size until now.<br>
(FIXED SIZE : width: 189 / heigh : 74 px)

Below is how to create BRDropDownView programmatically.<br>
(programmatically creating BRDropDownView is highly preffered.)<br>

```Swift

lazy var countdownView: BRDropDownView = {
let countdownView = BRDropDownView(timeSeconds: /* 30000 */ 5)
countdownView.animationStyle = .slideInFromBottom

/** you can make animate that you would like to perform in this closure if you would.
To do this, you should change animationStyle property to 'true'.
*/
//    countdownView.animationStyle = .custom
//    countdownView.customAnimation = {
//      [unowned self] animateView, duration in
//      UIView.animate(withDuration: duration, animations: {
//        animateView.alpha = 0.0
//      }, completion:{ finished in
//        if finished {
//          animateView.alpha = 1.0
//        }
//      })
//    }

countdownView.didFinish = {
[unowned self] (countdownView) -> Void in

DispatchQueue.main.async {
self.checkTestLabel.text = "countdown is finished..."
}

/** you can again repeat countdown with seconds you want whenever you want. */
// self.countdownView.repeatCountDown(in: 5)
}

countdownView.didRepeat = {
[unowned self] (countdownView) -> Void in

// it is fired when count-down repeat gets started.
DispatchQueue.main.async {
self.checkTestLabel.text = "countdown is repeated..."
}
}

countdownView.didResume = {
[unowned self] (countdownView) -> Void in
/**
do any task here if you need.
*/
print("didResume!")
}

countdownView.didTerminate = {
[unowned self] (countdownView) -> Void in
/**
do any task here if you need.
*/
print("didTerminate!")
}

countdownView.didStop = {
[unowned self] (countdownView) -> Void in
/**
do any task here if you need.
*/
print("didStop!")
}

countdownView.isUserInteractionEnabled = true
countdownView.didTouchBegin = {
[unowned self] sender in

print("didTouchBegin!?")
}

countdownView.didTouchEnd = {
[unowned self] sender in

print("didTouchEnd!?")
}

return countdownView
}()
```

<b>Step2. add BRDropDownView instance that programmatically created on a view hierachy that you need.</b>
<br>

```Swift
override func viewDidLoad() {
super.viewDidLoad()
// Do any additional setup after loading the view, typically from a nib.

self.view.addSubview(countdownView)

// get center.
countdownView.center = CGPoint(x: self.view.frame.size.width  / 2,
y: self.view.frame.size.height / 2)
}
```

## Author

Jang seoksoon, boraseoksoon@gmail.com

## License

BRDropDownView is available under the MIT license. See the LICENSE file for more info.

