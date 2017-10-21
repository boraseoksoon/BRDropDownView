
//
//  UILabel+Extension.swift
//  youtube
//
//  Created by Seoksoon Jang on 2017. 9. 29..
//  Copyright © 2017년 letsbuildthatapp. All rights reserved.
//

import UIKit

extension UILabel {
  var substituteFontName : String {
    get { return self.font.fontName }
    set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
  }
}
