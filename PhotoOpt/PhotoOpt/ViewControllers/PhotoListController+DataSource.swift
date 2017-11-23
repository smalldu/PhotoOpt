//
//  PhotoListController+DataSource.swift
//  PhotoOpt
//
//  Created by Zoey Shi on 2017/11/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDataSource,UICollectionViewDelegate

extension PhotoListController: UICollectionViewDataSource,UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseID, for: indexPath) as! PhotoCell
    guard let asset = self.category?.result?.object(at: indexPath.item) else { return UICollectionViewCell() }
    if #available(iOS 9.1, *) {
      if asset.mediaSubtypes.contains(.photoLive) {
        // Live
        cell.type = .live
      }else if asset.isGIF {
        cell.type = .gif
      }else{
        cell.type = .normal
      }
    } else {
      cell.type = .normal
    }
    cell.isCovered = SelectedAssetManager.shared.selectedCount >= maxSelectedCount 
    cell.isChoosed = SelectedAssetManager.shared.contains(asset)
    cell.representedAssetIdentifier = asset.localIdentifier
    imageManager.requestImage(for: asset , targetSize: self.thumbnailSize , contentMode: .aspectFill , options: nil) { (image, info ) in
      if cell.representedAssetIdentifier == asset.localIdentifier && image != nil {
        cell.thumbnailImage = image
      }
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let asset = self.category?.result?.object(at: indexPath.item) else { return }
    guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell else { return }
    
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
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.category?.result?.count ?? 0
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    updateCachedAssets()
  }
}




