//
//  PhotoCell.swift
//  PhotoOpt
//
//  Created by Zoey Shi on 2017/11/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

enum PhotoType: String {
  case live = "Live"
  case gif = "Gif"
  case normal
}
class PhotoCell: UICollectionViewCell {
  
  static let reuseID = "\(PhotoCell.self)"
  var representedAssetIdentifier: String = ""
  
  @IBOutlet weak var content: UIImageView!
  @IBOutlet weak var flag: UILabel!
  @IBOutlet weak var selectBtn: UIButton!
  
  var type: PhotoType = .normal {
    didSet{
      if type == .normal {
        flag.isHidden = true
      } else {
        flag.isHidden = false
        flag.text = type.rawValue
      }
    }
  }
  
  var thumbnailImage: UIImage? {
    didSet {
      content.image = thumbnailImage
    }
  }
  
  var isChoosed: Bool  = false{
    didSet{
      if isChoosed {
        selectBtn.tintColor = UIColor.blue
      }else{
        selectBtn.tintColor = UIColor.lightGray
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    content.contentMode = .scaleAspectFill
    content.clipsToBounds = true
    selectBtn.tintColor = UIColor.lightGray
  }
  
  func choosed(){
    UIView.animate(withDuration: 0.3, animations: {
      
    }) { b in
      
    }
    selectBtn.tintColor = UIColor.blue
  }
  
  func unchoosed(){
    
  }
  
  
}

