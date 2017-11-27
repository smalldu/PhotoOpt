//
//  AssetManager.swift
//  PhotoOpt
//
//  Created by Zoey Shi on 2017/11/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
import Photos
import ImageIO
import MobileCoreServices

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
  
  func generalGifImages(data: Data , complete: @escaping ((_ image: UIImage?)->())){
    DispatchQueue.global(qos: .background).async {
      let options: NSDictionary = [kCGImageSourceShouldCache as String: NSNumber(value: true), kCGImageSourceTypeIdentifierHint as String: kUTTypeGIF]
      guard let imageSource = CGImageSourceCreateWithData(data as CFData, options) else {
        fatalError("data error")
      }
      let frameCount = CGImageSourceGetCount(imageSource)
      var images = [UIImage]()
      print("帧数量为 \(frameCount)")
      var gifDuration = 0.0
      
      for i in 0 ..< frameCount {
        // 获取对应帧的 CGImage
        guard let imageRef = CGImageSourceCreateImageAtIndex(imageSource, i, options) else {
          fatalError("获取对应帧error")
        }
        if frameCount == 1 {
          // 单帧
          gifDuration = Double.infinity
        } else{
          // gif 动画
          // 获取到 gif每帧时间间隔
          guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) , let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
            let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else
          {
            fatalError("获取属性error")
          }
          //                print(frameDuration)
          gifDuration += frameDuration.doubleValue
          // 获取帧的img
          let  image = UIImage(cgImage: imageRef , scale: UIScreen.main.scale , orientation: .up)
          // 添加到数组
          images.append(image)
        }
      }
      DispatchQueue.main.async {
        let image = UIImage.animatedImage(with: images, duration: gifDuration)
        complete(image)
      }
    }
  }
  
}



