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
    let asset = fetchResult.object(at: indexPath.item)
    
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
    cell.representedAssetIdentifier = asset.localIdentifier
    imageManager.requestImage(for: asset , targetSize: self.thumbnailSize , contentMode: .aspectFill , options: nil) { (image, info ) in
      if cell.representedAssetIdentifier == asset.localIdentifier && image != nil {
        cell.thumbnailImage = image
      }
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.fetchResult.count
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    updateCachedAssets()
  }
}


