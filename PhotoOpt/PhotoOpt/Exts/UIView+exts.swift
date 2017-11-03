//
//  UIView+exts.swift
//  PhotoOpt
//
//  Created by duzhe on 2017/11/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

public extension UIView{
  
  public func addConstraintsWith(formart:String,views:UIView ...){
    var viewItems:[String:UIView] = [:]
    for (index,view) in views.enumerated(){
      viewItems["v\(index)"] = view
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formart, options: NSLayoutFormatOptions() , metrics: nil , views: viewItems))
  }
  
}
