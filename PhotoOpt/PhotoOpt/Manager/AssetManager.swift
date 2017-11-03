//
//  AssetManager.swift
//  PhotoOpt
//
//  Created by Zoey Shi on 2017/11/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
import Photos

class AssetManager {
  
  var allPhotos: PHFetchResult<PHAsset>
  init() {
    let allPhotosOptions = PHFetchOptions()
    allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    allPhotos = PHAsset.fetchAssets(with: .image, options: allPhotosOptions)
  }
  
  
  
  
  
  
}



