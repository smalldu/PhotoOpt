//
//  PhotoListController+Delegate.swift
//  PhotoOpt
//
//  Created by duzhe on 2017/11/23.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

extension PhotoListController: PhotoBottomViewDelegate, PhotoCellDelegate{
  
  func photoCellDidChoose(_ cell: PhotoCell) {
    guard let indexPath = collectionView.indexPath(for: cell) else {
      return
    }
    guard let asset = self.category?.result?.object(at: indexPath.item) else { return }
    if SelectedAssetManager.shared.selectedCount == maxSelectedCount - 1 && !SelectedAssetManager.shared.contains(asset) {
      SelectedAssetManager.shared.toggle(asset,image: cell.thumbnailImage)
      collectionView.reloadData()
    }else if SelectedAssetManager.shared.selectedCount == maxSelectedCount && SelectedAssetManager.shared.contains(asset){
      SelectedAssetManager.shared.toggle(asset,image: cell.thumbnailImage)
      collectionView.reloadData()
    }else if SelectedAssetManager.shared.selectedCount == maxSelectedCount &&  !SelectedAssetManager.shared.contains(asset) {
      return
    }else{
      SelectedAssetManager.shared.toggle(asset,image: cell.thumbnailImage)
    }
    cell.toggle()
    self.btmView.changeSelectedCount()
  }
  
  /// 预览
  func photoBottomViewDidPreview(_ view: PhotoBottomView) {
    if let result = self.category?.result {
      let previewController = PreviewController(result: result,maxCount:self.maxSelectedCount)
      previewController.listController = self
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


