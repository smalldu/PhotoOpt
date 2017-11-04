//
//  AssetItem.swift
//  PhotoOpt
//
//  Created by duzhe on 2017/11/4.
//  Copyright © 2017年 duzhe. All rights reserved.
//
import UIKit
import Photos

public class AssetItem {
  public var asset: PHAsset
  public var image: UIImage?
  public var exifInfo: [String: Any]?
  public var data: Data?
  public var uti: String?
  public var isGIF: Bool {
    return asset.isGIF
  }
  public init(asset: PHAsset) {
    self.asset = asset
  }
  
  public init(image: UIImage?,exifInfo: [String: Any]?){
    self.image = image
    self.asset = PHAsset()
    self.exifInfo = exifInfo
    if let image = self.image {
      self.data = UIImageJPEGRepresentation(image, 1)
    }
  }
  
  public func request(){
    if exifInfo != nil {
      return
    }
    self.requestExif()
    self.requestOthers()
  }
  
  func requestOthers(){
    let requestOption = PHImageRequestOptions()
    requestOption.version = .unadjusted
    requestOption.isSynchronous = false
    requestOption.isNetworkAccessAllowed = true
    PHImageManager.default().requestImageData(for: asset , options: requestOption) { [weak self] (data, uti,  orientation , info) in
      guard let `self` = self else { return }
      self.data = data
      self.uti = uti
    }
  }
  
  /// 获取exif信息
  func requestExif(){
    self.requestLocalURL { (url) in
      if let url = url {
        if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
          let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)
          if let p = properties as? [String: Any]{
            self.exifInfo = p
          }
        }
      }
    }
  }
  
  func requestLocalURL(_ completion: @escaping ((URL?) -> Void)){
    if asset.mediaType == .image {
      let options = PHContentEditingInputRequestOptions()
      options.canHandleAdjustmentData = { _ in
        return true
      }
      asset.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput, info) in
        completion(contentEditingInput?.fullSizeImageURL)
      })
    }else if asset.mediaType == .video {
      let options = PHVideoRequestOptions()
      options.version = .original
      PHImageManager.default().requestAVAsset(forVideo: asset, options: options, resultHandler: { (asset, audioMix, info) in
        if let urlAsset = asset as? AVURLAsset {
          let localVideoUrl = urlAsset.url
          completion(localVideoUrl)
        } else {
          completion(nil)
        }
      })
    }
  }
}


