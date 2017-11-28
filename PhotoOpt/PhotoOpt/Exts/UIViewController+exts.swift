//
//  UIViewController+exts.swift
//  PhotoOpt
//
//  Created by duzhe on 2017/11/28.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

extension UIViewController{
  
  func presentPhotos(_ maxCount: Int,complete:@escaping ((_ items: [AssetItem])->())){
    let plc = PhotoListController()
    plc.maxSelectedCount = maxCount
    let nav = UINavigationController(rootViewController: plc)
    plc.completeHandler { (items) in
      complete(items)
    }
    self.present(nav, animated: true, completion: nil)
  }
  
}
