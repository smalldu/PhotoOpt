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
  @IBOutlet weak var coverView: UIView!
  
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
  
  var isCovered: Bool = false
  
  var isChoosed: Bool  = false{
    didSet{
      if isChoosed {
        selectBtn.tintColor = UIColor.blue
        coverView.isHidden = true
      }else{
        selectBtn.tintColor = UIColor.lightGray
        // 是否不可选择状态
        coverView.isHidden = !isCovered
//        selectBtn.isUserInteractionEnabled = !isCovered
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    content.contentMode = .scaleAspectFill
    content.clipsToBounds = true
    selectBtn.tintColor = UIColor.lightGray
  }
  
  func toggle(){
    isChoosed = !isChoosed
    self.selectBtn.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
    UIView.animate(withDuration: 0.5 , delay: 0 , usingSpringWithDamping: 0.6 , initialSpringVelocity: 20 , options: .curveEaseOut , animations: {
      self.selectBtn.transform = CGAffineTransform.identity
    }, completion: nil)
  }
}

