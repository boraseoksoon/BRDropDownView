//
//  ViewController.swift
//  BRDropDownView
//
//  Created by boraseoksoon@gmail.com on 10/21/2017.
//  Copyright (c) 2017 boraseoksoon@gmail.com. All rights reserved.
//

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
  
  lazy var dropdownView: BRDropDownView = {
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
