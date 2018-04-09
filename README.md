# BRDropDownView

[![CI Status](http://img.shields.io/travis/boraseoksoon@gmail.com/BRDropDownView.svg?style=flat)](https://travis-ci.org/boraseoksoon@gmail.com/BRDropDownView)
[![Version](https://img.shields.io/cocoapods/v/BRDropDownView.svg?style=flat)](http://cocoapods.org/pods/BRDropDownView)
[![License](https://img.shields.io/cocoapods/l/BRDropDownView.svg?style=flat)](http://cocoapods.org/pods/BRDropDownView)
[![Platform](https://img.shields.io/cocoapods/p/BRDropDownView.svg?style=flat)](http://cocoapods.org/pods/BRDropDownView)

BRDropDownView : "Observe Y offset of targetView, then DropDown and Up Custom UI View that supports various styles."

<br>
<img src="https://media.giphy.com/media/xT9IgxnT3nu5qR3EK4/giphy.gif" width=240>
<img src="https://media.giphy.com/media/xT9IguEP7PMdSWjVHG/giphy.gif" width=240>
<img src="https://media.giphy.com/media/3ov9jTT0GedJRca6KQ/giphy.gif" width=240>
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
<b>BRDropDownView is highly recommend to be used programmatically</b>

see the below code in the included example project. <br>
it is straight-forward to use.

```Swift
import UIKit
import BRDropDownView

class ViewController: UIViewController {
  @IBOutlet var tableView: UITableView!
  var dropdownViewstyle: DropDownViewStyle = .typeA

  let firstOffSet: CGFloat = 0
  let secondOffSet: CGFloat = 1000.0
  let thirdOffSet: CGFloat = 2000.0
  let fourthOffSet: CGFloat = 3000.0

  let cellReusableIdentifier = "cellID"
  let sampleIdentifier0 = "Sample0"
  let sampleIdentifier1 = "Sample1"

  let heightOfDropDownView: CGFloat = 100.0

  lazy var dropdownView: BRDropDownView = { [unowned self] in
  let dropdownView = BRDropDownView(height: heightOfDropDownView,
  dropdownViewStyle: dropdownViewstyle)
  dropdownView.delegate = self
  dropdownView.triggerOffsetY = 20.0

  // Top Main 4 Properties
  // dropdownView.backButton
  // dropdownView.searchButton
  // dropdownView.shoppingCartButton
  // dropdownView.centerTopNoticeLabel.text = "Custom!"
  // dropdownView.centerTopNoticeLabel.textAlignment = .center

  // Bottom SubView Properties depending on given 3 style.
  switch dropdownViewstyle {
  case .typeA:
    dropdownView.countdownView.set(seconds:30)

    dropdownView.countdownView.didFinish = {
      [unowned self] sender in
      print("countdown finished!")
    }

    dropdownView.countdownView.didRepeat = {
      [unowned self] sender in
      print("countdown repeated!")
    }

  case .typeB:
    dropdownView.leftSubLabel.text = "left"
    dropdownView.leftSubLabel.font.withSize(10)
    dropdownView.leftSubLabel.textAlignment = .center
    dropdownView.leftSubLabel.sizeToFit()

    dropdownView.rightSubLabel.text = "right"
    dropdownView.rightSubLabel.font.withSize(10)
    dropdownView.rightSubLabel.textAlignment = .center
    dropdownView.rightSubLabel.sizeToFit()

    dropdownView.mainSubLabel.text = "main"
    dropdownView.mainSubLabel.font.withSize(14)
    dropdownView.mainSubLabel.textAlignment = .center
    dropdownView.mainSubLabel.sizeToFit()
  case .typeC:
    dropdownView.firstSectionLabelTapped = {
      [unowned self] in
      self.tableView.moveTo(offSet: self.firstOffSet)
    }

    dropdownView.secondSectionLabelTapped = {
      [unowned self] in
      self.tableView.moveTo(offSet: self.secondOffSet)
    }

    dropdownView.thirdSectionLabelTapped = {
      [unowned self] in
      self.tableView.moveTo(offSet: self.thirdOffSet)
    }

    dropdownView.fourthSectionLabelTapped = {
      [unowned self] in
      self.tableView.moveTo(offSet: self.fourthOffSet)
    }
  }

  return dropdownView
  }()

  private var isStatusBarHidden = true {
    didSet {
      setNeedsStatusBarAppearanceUpdate()
    }
  }

  override var prefersStatusBarHidden: Bool {
    return isStatusBarHidden
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReusableIdentifier)

    self.view.addSubview(self.dropdownView)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

// MARK: - BRDropDownViewDelegate Methods.
extension ViewController: BRDropDownViewDelegate {
  func didDropUpCompleted(sender: BRDropDownView) {
    print("didDropUpCompleted!")
  }

  func didDropDownCompleted(sender: BRDropDownView) {
    print("didDropDownCompleted!")
  }

  func backButtonDidTouch(sender: BRDropDownView) -> Void {
    print("backButtonDidTouch in delegate!")
    self.navigationController?.popViewController(animated: true)
  }

  func searchButtonDidTouch(sender: BRDropDownView) -> Void {
    print("searchButtonDidTouch in delegate!")
    self.performSegue(withIdentifier: sampleIdentifier0, sender: nil)
  }

  func shoppingCartButtonDidTouch(sender: BRDropDownView) -> Void {
    print("shoppingCartButtonDidTouch in delegate!")
    self.performSegue(withIdentifier: sampleIdentifier1, sender: nil)
  }
}

// MARK: - Own methods.
extension UITableView {
  func moveTo(offSet: CGFloat) -> Void {
    let point = CGPoint(x:0, y:offSet)
    self.setContentOffset(point, animated: true)
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource Methods.
extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 100
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReusableIdentifier, for: indexPath)

    cell.textLabel?.text = "\(indexPath.row)"
    cell.imageView?.image = #imageLiteral(resourceName: "image00")

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    dropdownView.observe(scrollView,
                         firstSectionOffSet: firstOffSet,
                         secondSectionOffSet: secondOffSet,
                         thirdSectionOffSet: thirdOffSet,
                         fourthSectionOffSet: fourthOffSet)
  }
}
```

<b>Trigger offset Y to make BRDropDownView drop down && up</b>
BRDropDownView animateds dropdown and up depending on triggerOffsetY property.<br>
you can set offset as below.<br>

```Swift
dropdownView.triggerOffsetY = 20.0
```

<b>Style C : Move to offset </b>
By touching 4 sections label on BRDropDown Style C,  you can make UITableView move to offset you would like to get.

```Swift
dropdownView.firstSectionLabelTapped = {
  [unowned self] in
  self.tableView.moveTo(offSet: self.firstOffSet)
}

dropdownView.secondSectionLabelTapped = {
  [unowned self] in
  self.tableView.moveTo(offSet: self.secondOffSet)
}

dropdownView.thirdSectionLabelTapped = {
  [unowned self] in
  self.tableView.moveTo(offSet: self.thirdOffSet)
}

dropdownView.fourthSectionLabelTapped = {
  [unowned self] in
  self.tableView.moveTo(offSet: self.fourthOffSet)
}
```
BRDropDownView can observe scroll offset Y.<br>
depending on offset Y, a proper section is displayed to notify where offset Y is being passed while user scroll table view.
```Swift
func scrollViewDidScroll(_ scrollView: UIScrollView) {
  dropdownView.observe(scrollView,
                       firstSectionOffSet: firstOffSet,
                       secondSectionOffSet: secondOffSet,
                       thirdSectionOffSet: thirdOffSet,
                       fourthSectionOffSet: fourthOffSet)
}
```

<b>BRDropDownView Styles</b>
You can use one of three type as built-in BRDropDownView style.
```Swift
public enum DropDownViewStyle: Int {
  case typeA
  case typeB
  case typeC
}

let dropdownViewstyle: DropDownViewStyle = .typeC
let dropdownView = BRDropDownView(height: 100.0, dropdownViewStyle: dropdownViewstyle)
```

<b>Customize</b>
you can customize BRDropDownView by using exposed APIs.<br>
The example code is below.
```Swift

// Bottom SubView Properties depending on given 3 style.
switch dropdownViewstyle {
  case .typeA:
    dropdownView.countdownView.set(seconds:30)

    dropdownView.countdownView.didFinish = {
      [unowned self] sender in
      print("countdown finished!")
    }

    dropdownView.countdownView.didRepeat = {
      [unowned self] sender in
      print("countdown repeated!")
    }

  case .typeB:
    dropdownView.leftSubLabel.text = "left"
    dropdownView.leftSubLabel.font.withSize(10)
    dropdownView.leftSubLabel.textAlignment = .center
    dropdownView.leftSubLabel.sizeToFit()

    dropdownView.rightSubLabel.text = "right"
    dropdownView.rightSubLabel.font.withSize(10)
    dropdownView.rightSubLabel.textAlignment = .center
    dropdownView.rightSubLabel.sizeToFit()

    dropdownView.mainSubLabel.text = "main"
    dropdownView.mainSubLabel.font.withSize(14)
    dropdownView.mainSubLabel.textAlignment = .center
    dropdownView.mainSubLabel.sizeToFit()
  case .typeC:
    dropdownView.firstSectionLabelTapped = {
      [unowned self] in
      self.tableView.moveTo(offSet: self.firstOffSet)
    }

    dropdownView.secondSectionLabelTapped = {
      [unowned self] in
      self.tableView.moveTo(offSet: self.secondOffSet)
    }

    dropdownView.thirdSectionLabelTapped = {
      [unowned self] in
      self.tableView.moveTo(offSet: self.thirdOffSet)
    }

    dropdownView.fourthSectionLabelTapped = {
      [unowned self] in
      self.tableView.moveTo(offSet: self.fourthOffSet)
    }
}
```

<b>BRDropDownViewDelegate Methods</b>
Event can be traditionally notified through delegate.<br>

```Swift

// MARK: - BRDropDownViewDelegate protocols.
public protocol BRDropDownViewDelegate: NSObjectProtocol {
  func didDropDownCompleted(sender: BRDropDownView) -> Void
  func didDropUpCompleted(sender: BRDropDownView) -> Void
  func backButtonDidTouch(sender: BRDropDownView) -> Void
  func searchButtonDidTouch(sender: BRDropDownView) -> Void
  func shoppingCartButtonDidTouch(sender: BRDropDownView) -> Void
}

....
...
..
.

dropdownView.delegate = self

extension ViewController: BRDropDownViewDelegate {
  func didDropUpCompleted(sender: BRDropDownView) {
    print("didDropUpCompleted!")
  }

  func didDropDownCompleted(sender: BRDropDownView) {
    print("didDropDownCompleted!")
  }

  func backButtonDidTouch(sender: BRDropDownView) -> Void {
    print("backButtonDidTouch in delegate!")
    self.navigationController?.popViewController(animated: true)
  }

  func searchButtonDidTouch(sender: BRDropDownView) -> Void {
    print("searchButtonDidTouch in delegate!")
    self.performSegue(withIdentifier: sampleIdentifier0, sender: nil)
  }

  func shoppingCartButtonDidTouch(sender: BRDropDownView) -> Void {
    print("shoppingCartButtonDidTouch in delegate!")
    self.performSegue(withIdentifier: sampleIdentifier1, sender: nil)
  }
}
```

## Author

Jang seoksoon, boraseoksoon@gmail.com

## License

BRDropDownView is available under the MIT license. See the LICENSE file for more info.
