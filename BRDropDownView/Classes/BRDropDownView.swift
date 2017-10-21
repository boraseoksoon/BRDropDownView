//
//  BRDropDownView.swift
//  BRDropDownView
//
//  Created by Seoksoon Jang on 2017. 10. 12..
//  Copyright © 2017년 Seoksoon Jang. All rights reserved.
//

import UIKit
import BRCountDownView

public enum DropDownViewStyle: Int {
  case typeA
  case typeB
  case typeC
}

// MARK: - BRDropDownViewDelegate protocols.
public protocol BRDropDownViewDelegate: NSObjectProtocol {
  func didDropDownCompleted(sender: BRDropDownView) -> Void
  func didDropUpCompleted(sender: BRDropDownView) -> Void
  func backButtonDidTouch(sender: BRDropDownView) -> Void
  func searchButtonDidTouch(sender: BRDropDownView) -> Void
  func shoppingCartButtonDidTouch(sender: BRDropDownView) -> Void
}

final public class BRDropDownView: UIView {
  // MARK: - Properties.
  public weak var delegate: BRDropDownViewDelegate?
  public var dropdownViewStyle: DropDownViewStyle = .typeC
  
  // MARK:- 4 properties on Top Common DropDown View Side.
  public let backButton = UIButton(type: UIButtonType.custom)
  public let shoppingCartButton = UIButton(type: UIButtonType.custom)
  public let searchButton = UIButton(type: UIButtonType.custom)
  public let centerTopNoticeLabel = UILabel()
  
  // MARK:- Common Properties
  public let animationDuration: TimeInterval = 0.3
  public var heightOfDropDownView: CGFloat = 103.0
  
  public let buttonWidth: CGFloat = 25.0
  public let buttonHeight: CGFloat = 25.0
  
  // MARK:- for style A
  public let countdownView = BRCountDownView(timeSeconds: 10)
  public var countdownFinished: ((BRCountDownView) -> Void)?
  public var countdownRepeated: ((BRCountDownView) -> Void)?
  
  // MARK:- for style B.
  public let leftSubLabel = UILabel()
  public let rightSubLabel = UILabel()
  public let mainSubLabel = UILabel()
  
  // MARK:- for style C.
  public let firstSectionLabel = UILabel()
  public let secondSectionLabel = UILabel()
  public let thirdSectionLabel = UILabel()
  public let fourthSectionLabel = UILabel()
  
  public var firstSectionLabelTapped: (() -> Void)?
  public var secondSectionLabelTapped: (() -> Void)?
  public var thirdSectionLabelTapped: (() -> Void)?
  public var fourthSectionLabelTapped: (() -> Void)?
  
  // MARK:- Frames
  public lazy var triggerOffsetY: CGFloat = {
    return self.frame.size.height
  }()
  
  public lazy var centerHeightOfSubBottomView = {
    return (self.heightOfDropDownView / 2) / 2
  }()
  
  public lazy var centerWidthOfSubBottomView = {
    return (self.widthOfDropDownView / 2)
  }()
  
  public lazy var centerHeightOfSubTopView = {
    return (self.heightOfDropDownView) / 2
  }()
  
  public lazy var centerWidthOfSubTopView = {
    return (self.widthOfDropDownView / 2)
  }()
  
  // MARK:- Flags
  fileprivate var isLayoutSubviewsCalled: Bool = false
  
  fileprivate var isDropdownAnimated: Bool = false
  fileprivate var isDropdownDown: Bool = false
  fileprivate var isDropdownTop: Bool = false
  
  fileprivate let widthOfDropDownView = UIScreen.main.bounds.size.width
  
  fileprivate lazy var sectionLabelList: [UILabel] = {
    return [self.firstSectionLabel, self.secondSectionLabel, self.thirdSectionLabel, self.fourthSectionLabel]
  }()
  
  fileprivate let fontStringToUse = "PingFangSC-Regular"
  
  // MARK:- Life Cycle Methods
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initPhase(height: self.heightOfDropDownView, with: dropdownViewStyle)
  }
  
  public required init(height: CGFloat, dropdownViewStyle: DropDownViewStyle) {
    super.init(
      frame:
      CGRect(
        x: 0,
        y: 0,
        width: self.widthOfDropDownView,
        height: self.heightOfDropDownView
      )
    )
    initPhase(height: height, with: dropdownViewStyle)
  }
  
  fileprivate func initPhase(height: CGFloat, with dropdownViewStyle: DropDownViewStyle) {
    self.heightOfDropDownView = height
    self.dropdownViewStyle = dropdownViewStyle
    self.frame = self.stackView.frame
    
    self.isHidden = true
    
    self.backgroundColor = .clear
    self.addSubview(self.eventVisualEffectView)
    self.addSubview(self.stackView)
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    
    if !isLayoutSubviewsCalled {
      isLayoutSubviewsCalled = true
      
      // pending shadow
      let shadowPath = UIBezierPath(rect: bounds)
      layer.masksToBounds = false
      layer.shadowColor = UIColor.init(red: 221/255, green: 221/255, blue: 221/255, alpha: 0.5).cgColor
      layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
      layer.shadowOpacity = 0.5
      layer.shadowPath = shadowPath.cgPath
      
      let bottomBordercolor = UIColor.init(red: 221/255,
                                           green: 221/255,
                                           blue: 221/255,
                                           alpha: 0.5).withAlphaComponent(0.5)
      self.addBottomBorderWithColor(color: bottomBordercolor,
                                    width:1.0)
    }
  }
  
  // MARK:- Target && Actions Methods.
  @objc fileprivate func backButtonTouched() -> Void {
    print("backbuttonTouched!!!")
    delegate?.backButtonDidTouch(sender: self)
  }
  
  @objc fileprivate func shoppingCartButtonTouched() -> Void {
    print("shoppingCartButtonTouched!")
    delegate?.shoppingCartButtonDidTouch(sender: self)
  }
  
  @objc fileprivate func searchButtonTouched() -> Void {
    print("searchButtonTouched!")
    delegate?.searchButtonDidTouch(sender: self)
  }
  
  @objc func productOverViewSectionLabelTapped(_ sender: Any) -> Void {
    self.firstSectionLabelTapped!()
    self.changeSectionColor(at: self.firstSectionLabel)
  }
  
  @objc func reviewSectionLabelTapped(_ sender: Any) -> Void {
    self.secondSectionLabelTapped!()
    self.changeSectionColor(at: self.secondSectionLabel)
  }
  
  @objc func productDetailImageSectionLabelTapped(_ sender: Any) -> Void {
    self.thirdSectionLabelTapped!()
    self.changeSectionColor(at: self.thirdSectionLabel)
  }
  
  @objc func productDetailInfoSectionLabelTapped(_ sender: Any) -> Void {
    self.fourthSectionLabelTapped!()
    self.changeSectionColor(at: self.fourthSectionLabel)
  }
  
  // MARK:- SubView Properties.
  fileprivate lazy var stackView: UIStackView = {
    let topEventIndicatorSubView = UIView()
    
    let bottomEventContentsSubView = UIView()
    
    #if COLOR_LAYER_DEBUG
      bottomEventContentsSubView.layer.borderColor = UIColor.blue.cgColor
      bottomEventContentsSubView.layer.borderWidth = 5
      
      topEventIndicatorSubView.layer.borderColor = UIColor.yellow.cgColor
      topEventIndicatorSubView.layer.borderWidth = 0.5
    #endif
    
    /// In Top Stack SubView
    
    /// Three Buttons on Top
    let backButtonImage = self.bundledImage(named: "btnBackBlack")
    
    self.backButton.setImage(backButtonImage, for: .normal)
    self.backButton.sizeToFit()
    topEventIndicatorSubView.addSubview(self.backButton)
    self.backButton.frame = CGRect(x: 10, y: 15, width: self.buttonWidth, height: self.buttonHeight)
    self.backButton.addTarget(self, action: #selector(backButtonTouched), for:.touchUpInside)
    
    let shoppingCartButtonImage = self.bundledImage(named:"btnShoppingBagBlack")
    self.shoppingCartButton.setImage(shoppingCartButtonImage, for: .normal)
    self.shoppingCartButton.sizeToFit()
    topEventIndicatorSubView.addSubview(self.shoppingCartButton)
    self.shoppingCartButton.frame = CGRect(x: self.widthOfDropDownView - 15 - self.shoppingCartButton.frame.size.width,
                                           y: 15,
                                           width: self.buttonWidth,
                                           height: self.buttonHeight)
    self.shoppingCartButton.addTarget(self, action: #selector(shoppingCartButtonTouched), for:.touchUpInside)
    
    let searchButtonImage = self.bundledImage(named:"btnSearchBlack")
    self.searchButton.setImage(searchButtonImage, for: .normal)
    self.searchButton.sizeToFit()
    topEventIndicatorSubView.addSubview(self.searchButton)
    self.searchButton.frame = CGRect(x: self.shoppingCartButton.frame.origin.x - 10 - self.shoppingCartButton.frame.size.width,
                                     y: 15,
                                     width: self.buttonWidth,
                                     height: self.buttonHeight)
    
    self.searchButton.addTarget(self, action: #selector(searchButtonTouched), for:.touchUpInside)
    
    /// Top Label
    topEventIndicatorSubView.addSubview(self.centerTopNoticeLabel)
    self.centerTopNoticeLabel.text = "BRDropDownView"
    self.centerTopNoticeLabel.font = UIFont(name: self.fontStringToUse, size: 18)
    self.centerTopNoticeLabel.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
    self.centerTopNoticeLabel.sizeToFit()
    // center X
    self.centerTopNoticeLabel.center = CGPoint(x:self.centerWidthOfSubTopView,
                                               y:0);
    
    var centerLabelFrame = self.centerTopNoticeLabel.frame;
    centerLabelFrame.origin.y = self.backButton.frame.origin.y
    self.centerTopNoticeLabel.frame = centerLabelFrame;
    
    /// In Bottom Stack SubView
    
    switch self.dropdownViewStyle {
    case .typeA:
      print("typeA!")
      
      #if COLOR_LAYER_DEBUG
        countdownView.layer.borderColor = UIColor.red.cgColor
        countdownView.layer.borderWidth = 5
      #endif
      
      bottomEventContentsSubView.addSubview(self.countdownView)
      
      self.countdownView.center = CGPoint(x: self.centerWidthOfSubBottomView,
                                          y: self.centerHeightOfSubBottomView)
      
    case .typeB:
      // left label
      bottomEventContentsSubView.addSubview(self.leftSubLabel)
      
      self.leftSubLabel.text = "테스트라벨1"
      self.leftSubLabel.font = UIFont(name: self.fontStringToUse, size: 12)
      self.leftSubLabel.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
      self.leftSubLabel.sizeToFit()
      
      // change X
      var leftSubLabelFrame = self.leftSubLabel.frame;
      leftSubLabelFrame.origin.x = 20
      leftSubLabelFrame.origin.y = 18
      self.leftSubLabel.frame = leftSubLabelFrame;
      
      #if COLOR_LAYER_DEBUG
        leftSubLabel.layer.borderColor = UIColor.blue.cgColor
        leftSubLabel.layer.borderWidth = 2.0
      #endif
      
      // right label
      bottomEventContentsSubView.addSubview(self.rightSubLabel)
      
      self.rightSubLabel.text = "테스트라벨2"
      self.rightSubLabel.font = UIFont(name: self.fontStringToUse, size: 12)
      self.rightSubLabel.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
      self.rightSubLabel.sizeToFit()
      
      // change X
      var rightSubLabelFrame = self.rightSubLabel.frame;
      rightSubLabelFrame.origin.x = self.leftSubLabel.frame.origin.x + self.leftSubLabel.frame.size.width + 11
      rightSubLabelFrame.origin.y = self.leftSubLabel.frame.origin.y
      self.rightSubLabel.frame = rightSubLabelFrame;
      #if COLOR_LAYER_DEBUG
        rightSubLabel.layer.borderColor = UIColor.blue.cgColor
        rightSubLabel.layer.borderWidth = 2.0
      #endif
      
      // main label
      bottomEventContentsSubView.addSubview(self.mainSubLabel)
      
      self.mainSubLabel.text = "테스트라벨3"
      self.mainSubLabel.font = UIFont(name: self.fontStringToUse, size: 20)
      self.mainSubLabel.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
      self.mainSubLabel.sizeToFit()
      
      self.mainSubLabel.center = CGPoint(x: self.centerWidthOfSubBottomView,
                                         y: self.centerHeightOfSubBottomView)
      
      var mainSubLabelFrame = self.mainSubLabel.frame;
      mainSubLabelFrame.origin.x = self.widthOfDropDownView - 20 - mainSubLabelFrame.size.width
      self.mainSubLabel.frame = mainSubLabelFrame;
      
      #if COLOR_LAYER_DEBUG
        mainSubLabel.layer.borderColor = UIColor.blue.cgColor
        mainSubLabel.layer.borderWidth = 2.0
      #endif
      
    case .typeC:
      print("typeC!")
      
      let sectionLabelFontSize: CGFloat = 14.0
      
      self.firstSectionLabel.text = "first"
      self.firstSectionLabel.font = UIFont(name: self.fontStringToUse, size: sectionLabelFontSize)
      self.firstSectionLabel.textColor = UIColor.sectionWarmGrey
      self.firstSectionLabel.sizeToFit()
      self.firstSectionLabel.textAlignment = .center
      
      let productOverViewSectionLabelTapAction =
        UITapGestureRecognizer(target: self,
                               action: #selector(self.productOverViewSectionLabelTapped(_:)))
      self.firstSectionLabel.isUserInteractionEnabled = true
      self.firstSectionLabel.addGestureRecognizer(productOverViewSectionLabelTapAction)
      
      self.secondSectionLabel.text = "second"
      self.secondSectionLabel.font = UIFont(name: self.fontStringToUse, size: sectionLabelFontSize)
      self.secondSectionLabel.textColor = UIColor.sectionWarmGrey
      self.secondSectionLabel.sizeToFit()
      self.secondSectionLabel.textAlignment = .center
      
      let reviewSectionLabelTapAction =
        UITapGestureRecognizer(target: self,
                               action: #selector(self.reviewSectionLabelTapped(_:)))
      self.secondSectionLabel.isUserInteractionEnabled = true
      self.secondSectionLabel.addGestureRecognizer(reviewSectionLabelTapAction)
      
      self.thirdSectionLabel.text = "third"
      self.thirdSectionLabel.font = UIFont(name: self.fontStringToUse, size: sectionLabelFontSize)
      self.thirdSectionLabel.textColor = UIColor.sectionWarmGrey
      self.thirdSectionLabel.sizeToFit()
      self.thirdSectionLabel.textAlignment = .center
      
      let productDetailImageSectionLabelTapAction =
        UITapGestureRecognizer(target: self,
                               action: #selector(self.productDetailImageSectionLabelTapped(_:)))
      self.thirdSectionLabel.isUserInteractionEnabled = true
      self.thirdSectionLabel.addGestureRecognizer(productDetailImageSectionLabelTapAction)
      
      self.fourthSectionLabel.text = "fourth"
      self.fourthSectionLabel.font = UIFont(name: self.fontStringToUse, size: sectionLabelFontSize)
      self.fourthSectionLabel.textColor = UIColor.sectionWarmGrey
      self.fourthSectionLabel.sizeToFit()
      self.fourthSectionLabel.textAlignment = .center
      
      let productDetailInfoSectionLabelTapAction =
        UITapGestureRecognizer(target: self,
                               action: #selector(self.productDetailInfoSectionLabelTapped(_:)))
      self.fourthSectionLabel.isUserInteractionEnabled = true
      self.fourthSectionLabel.addGestureRecognizer(productDetailInfoSectionLabelTapAction)
      
      let sectionLabelList = [self.firstSectionLabel, self.secondSectionLabel, self.thirdSectionLabel, self.fourthSectionLabel]
      
      let stackView = UIStackView(arrangedSubviews:sectionLabelList)
      stackView.distribution = .fillEqually
      stackView.axis = .horizontal
      stackView.frame = CGRect(x: 0,
                               y: 0,
                               width: self.widthOfDropDownView,
                               height: self.heightOfDropDownView / 2.0)
      bottomEventContentsSubView.addSubview(stackView)
    }
    
    let stackView = UIStackView(arrangedSubviews:[topEventIndicatorSubView, bottomEventContentsSubView])
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    stackView.frame = CGRect(x: 0,
                             y: 0,
                             width: self.widthOfDropDownView,
                             height: self.heightOfDropDownView)
    stackView.backgroundColor = .clear
    
    return stackView
  }()
  
  lazy var eventVisualEffectView: UIVisualEffectView = {
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
    blurEffectView.alpha = 0.8
    blurEffectView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.widthOfDropDownView,
                                  height: self.heightOfDropDownView)
    
    #if COLOR_LAYER_DEBUG
      blurEffectView.layer.borderColor = UIColor.blue.cgColor
      blurEffectView.layer.borderWidth = 2.0
    #endif
    
    return blurEffectView
  }()
}

extension BRDropDownView {
  public func changeSectionColor(at targetSectionLabel: UILabel) -> Void {
    for label in sectionLabelList {
      if label == targetSectionLabel {
        label.textColor = UIColor.iosWarmPink
      } else {
        label.textColor = UIColor.sectionWarmGrey
      }
    }
  }
  
  public func startNotify(_ scrollView :UIScrollView,
                          firstSectionOffSet: CGFloat? = nil,
                          secondSectionOffSet: CGFloat? = nil,
                          thirdSectionOffSet: CGFloat? = nil,
                          fourthSectionOffSet: CGFloat? = nil) -> Void {
    print("offSet check : ", scrollView.contentOffset.y)
    if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
      //reach bottom
      print("bottom!")
    }
    
    if (scrollView.contentOffset.y <= 0){
      //reach top
      print("reach top!")
    }
    
    if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
      // not top and not bottom
      // print("in the middle : ", scrollView.contentOffset.y)
      
      if scrollView.contentOffset.y >= triggerOffsetY {
        if !isDropdownAnimated {
          if !isDropdownDown {
            UIView.animate(withDuration: animationDuration, delay:0, animations: {
              [unowned self] in
              //bottom
              self.isDropdownAnimated = true
              self.isDropdownTop = false
              self.isDropdownDown = true
              
              self.frame.origin.y = self.frame.origin.y + self.frame.size.height + 20
              self.alpha = 1.0
              }, completion: { [unowned self] isFinished in
                if isFinished {
                  self.isDropdownAnimated = false
                  // do your job if you need some more.
                  self.delegate?.didDropDownCompleted(sender: self)
                }
            })
          }
        }
      } else if scrollView.contentOffset.y <= triggerOffsetY {
        if !isDropdownAnimated {
          if !isDropdownTop {
            UIView.animate(withDuration: animationDuration, animations: { [unowned self] in
              // top
              self.isDropdownAnimated = true
              self.isDropdownTop = true
              self.isDropdownDown = false
              
              self.frame.origin.y = self.frame.origin.y - self.frame.size.height - 20
              self.alpha = 0.3
              }, completion: { [unowned self] isFinished in
                if isFinished {
                  self.alpha = 1.0
                  self.isDropdownAnimated = false
                  self.isHidden = false
                  self.delegate?.didDropUpCompleted(sender: self)
                }
            })
          }
        }
      }
    }
    
    guard let firstSectionOffSet = firstSectionOffSet,
      let secondSectionOffSet = secondSectionOffSet,
      let thirdSectionOffSet = thirdSectionOffSet,
      let fourthSectionOffSet = fourthSectionOffSet
      else { return }
    
    if scrollView.contentOffset.y >= firstSectionOffSet {
      print("dropDownView passed firstSectionOffSet!")
      // self.productOverViewSectionLabelTapped!()
      self.changeSectionColor(at: self.firstSectionLabel)
    }
    
    if scrollView.contentOffset.y >= secondSectionOffSet {
      print("dropDownView passed secondSectionOffSet!")
      // self.reviewSectionLabelTapped!()
      self.changeSectionColor(at: self.secondSectionLabel)
    }
    
    if scrollView.contentOffset.y >= thirdSectionOffSet {
      print("dropDownView passed thirdSectionOffSet!")
      // self.productDetailImageSectionLabelTapped!()
      self.changeSectionColor(at: self.thirdSectionLabel)
    }
    
    if scrollView.contentOffset.y >= fourthSectionOffSet {
      print("dropDownView passed fourthSectionOffSet!")
      // self.productDetailImageSectionLabelTapped!()
      self.changeSectionColor(at: self.fourthSectionLabel)
    }
  }
  
  func bundledImage(named: String) -> UIImage? {
    let image = UIImage(named: named)
    if image == nil {
      return UIImage(named:named, in:Bundle(for: BRDropDownView.self), compatibleWith: nil)
    }
    return image
  }
}
