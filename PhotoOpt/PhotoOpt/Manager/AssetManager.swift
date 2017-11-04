//
//  AssetManager.swift
//  PhotoOpt
//
//  Created by Zoey Shi on 2017/11/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
import Photos

struct AssetCategory {
  
  var title: String?
  var count: Int?
  var result: PHFetchResult<PHAsset>?
  var collection: PHAssetCollection? {
    didSet{
      guard let collection = self.collection else { return }
      let option = PHFetchOptions()
      // 按照创建时间排序
      option.sortDescriptors = [
        NSSortDescriptor(key: "creationDate", ascending: false)
      ]
      // 过滤出图片
      option.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
      self.result = PHAsset.fetchAssets(in: collection, options: option)
      self.count = self.result?.count
      self.title = collection.localizedTitle ?? ""
    }
  }
  
}

class AssetManager {
  
  var firstCategory: AssetCategory
  var allPhotos: PHFetchResult<PHAsset>
  var smartAlbums: PHFetchResult<PHAssetCollection>!
  var userCollections: PHFetchResult<PHCollection>!
  var categorys: [AssetCategory] = []
  
  init() {
    let allPhotosOptions = PHFetchOptions()
    allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    allPhotos = PHAsset.fetchAssets(with: .image, options: allPhotosOptions)
    firstCategory = AssetCategory()
    firstCategory.result = allPhotos
    firstCategory.title = NSLocalizedString("所有照片", comment: "")
    firstCategory.count = allPhotos.count
  }
  
  func fetchOthers(){
    categorys.removeAll()
    categorys.append(firstCategory)
    
    DispatchQueue.global(qos: .background).async {
      self.smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
      self.userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
      for i in 0..<self.smartAlbums.count {
        var category = AssetCategory()
        category.collection = self.smartAlbums.object(at: i)
        self.categorys.append(category)
      }
      for i in 0..<self.userCollections.count {
        if let collection = self.userCollections.object(at: i) as? PHAssetCollection{
          var category = AssetCategory()
          category.collection = collection
          self.categorys.append(category)
        }
      }
    }
  }
  
}



