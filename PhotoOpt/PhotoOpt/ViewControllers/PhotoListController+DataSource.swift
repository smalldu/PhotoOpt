//
//  PhotoListController+DataSource.swift
//  PhotoOpt
//
//  Created by Zoey Shi on 2017/11/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

// MARK: - UICollectionViewDataSource,UICollectionViewDelegate

extension PhotoListController: UICollectionViewDataSource,UICollectionViewDelegate {
  //implements UICollectionViewDelegate
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseID, for: indexPath) as! PhotoCell
    guard let asset = self.category?.result?.object(at: indexPath.item) else { return UICollectionViewCell() }
    if asset.mediaSubtypes.contains(.photoLive) {
      // Live
      cell.type = .live
    }else if asset.isGIF {
      cell.type = .gif
    }else{
      cell.type = .normal
    }
    cell.isCovered = SelectedAssetManager.shared.selectedCount >= maxSelectedCount 
    cell.isChoosed = SelectedAssetManager.shared.contains(asset)
    cell.representedAssetIdentifier = asset.localIdentifier
    cell.delegate = self
    
    if photoCache[asset] == nil {
      photoCache[asset] = PhotoListCache()
    }
    if let image = photoCache[asset]?.image{
      // 从缓存中获取
      if cell.representedAssetIdentifier == asset.localIdentifier{
        cell.thumbnailImage = image
      }
    }else{
      imageManager.requestImage(for: asset , targetSize: self.thumbnailSize , contentMode: .aspectFill , options: nil) { (image, info ) in
        if cell.representedAssetIdentifier == asset.localIdentifier && image != nil {
          self.photoCache[asset]?.image = image
          cell.thumbnailImage = image
        }
      }
    }
    
    if cell.type == .live {
      if let url = photoCache[asset]?.movURL {
        cell.movURL = url
      }else{
        self.imageManager.requestLivePhoto(for: asset, targetSize: self.thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { [weak self] (livePhoto, info) in
          guard let `self` = self else{ return }
          // live photo
          if let livePhoto = livePhoto{
            let assetResources = PHAssetResource.assetResources(for: livePhoto)
            for item in assetResources{
              print("\(item.originalFilename) , \(item.type)")
              if item.originalFilename.lowercased().contains(".mov"){
                // 保存到缓存目录
                let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                let path = (paths.first ?? "") + "/\(item.originalFilename)"
                let url = URL(fileURLWithPath: path)
                if self.fileManager.fileExists(atPath: path){
                  DispatchQueue.main.async {
                    self.photoCache[asset]?.movURL = url
                    cell.movURL = url
                  }
                }else{
                  PHAssetResourceManager.default().writeData(for: item, toFile: url, options: nil, completionHandler: { [weak self] (error) in
                    guard let `self` = self else{ return }
                    if error == nil {
                      DispatchQueue.main.async {
                        self.photoCache[asset]?.movURL = url
                        cell.movURL = url
                      }
                    }
                  })
                }
              }
            }
          }
        })
      }
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let result = self.category?.result {
      let previewController = PreviewController(result: result,maxCount:self.maxSelectedCount)
      previewController.listController = self
      previewController.indexPath = indexPath
      self.navigationController?.pushViewController(previewController, animated: true)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.category?.result?.count ?? 0
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    updateCachedAssets()
  }
}




