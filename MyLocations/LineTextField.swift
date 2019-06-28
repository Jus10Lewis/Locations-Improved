//
//  LineTextField.swift
//  MyLocations
//
//  Created by Justin Lewis on 6/18/19.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import UIKit

class LineTextField: UITextField {

  override func awakeFromNib() {
    super.awakeFromNib()
    let line = CALayer()
    line.frame = CGRect(x: 0, y: self.frame.height - 2, width: self.frame.width, height: 2)
    line.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
    borderStyle = .none

    layer.addSublayer(line)
  }

}
