//
//  PhotoListController+Delegate.swift
//  PhotoOpt
//
//  Created by duzhe on 2017/11/23.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

extension PhotoListController: PhotoBottomViewDelegate{
  
  /// 预览
  func photoBottomViewDidPreview(_ view: PhotoBottomView) {
    if let result = self.category?.result {
      let previewController = PreviewController(result: result)
      self.navigationController?.pushViewController(previewController, animated: true)
    }
  }
  
  /// 完成
  func photoBottomViewDidComplete(_ view: PhotoBottomView) {
    self.dismiss(animated: true) { [weak self] in
      guard let `self` = self else{ return }
      // 回调
      self.complete?( SelectedAssetManager.shared.items )
    }
  }
  
}


