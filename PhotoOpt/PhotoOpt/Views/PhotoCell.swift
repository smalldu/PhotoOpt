//
//  PhotoCell.swift
//  PhotoOpt
//
//  Created by Zoey Shi on 2017/11/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
import AVFoundation

enum PhotoType: String {
  case live = "Live"
  case gif = "Gif"
  case normal
}

protocol PhotoCellDelegate: class {
  func photoCellDidChoose(_ cell: PhotoCell)
}

class PhotoCell: UICollectionViewCell {
  
  static let reuseID = "\(PhotoCell.self)"
  var representedAssetIdentifier: String = ""
  weak var delegate: PhotoCellDelegate?
  
  @IBOutlet weak var content: UIImageView!
  @IBOutlet weak var flag: UILabel!
  @IBOutlet weak var selectBtn: UIButton!
  @IBOutlet weak var coverView: UIView!
  @IBOutlet weak var playerView: PlayerView!
  @IBOutlet weak var liveButton: UIButton!
  
  var type: PhotoType = .normal {
    didSet{
      liveButton.isHidden = type != .live
      if type != .live{
        playerView.isHidden = true
      }
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
  var movURL: URL? {
    didSet{
      if let url = movURL{
        playerView.configWithURL(url)
      }
    }
  }
  
  
  var isChoosed: Bool  = false{
    didSet{
      if isChoosed {
        selectBtn.tintColor = UIColor.blue
        coverView.isHidden = true
        selectBtn.isUserInteractionEnabled = true
      }else{
        selectBtn.tintColor = UIColor.lightGray
        // 是否不可选择状态
        coverView.isHidden = !isCovered
        selectBtn.isUserInteractionEnabled = !isCovered
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    playerView.isHidden = true
    coverView.isUserInteractionEnabled = true
    content.contentMode = .scaleAspectFill
    content.clipsToBounds = true
    selectBtn.tintColor = .lightGray
    selectBtn.addTarget(self, action: #selector(selectBtnClick), for: .touchUpInside)
    liveButton.addTarget(self, action: #selector(playLive), for: .touchUpInside)
    playerView.delegate = self
  }
  
  
  @objc func selectBtnClick(){
    delegate?.photoCellDidChoose(self)
  }
  
  @objc func playLive(){
    playerView.isHidden = false
    playerView.play()
  }
  
  func toggle(){
    isChoosed = !isChoosed
    self.selectBtn.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
    UIView.animate(withDuration: 0.5 , delay: 0 , usingSpringWithDamping: 0.6 , initialSpringVelocity: 20 , options: .curveEaseOut , animations: {
      self.selectBtn.transform = CGAffineTransform.identity
    }, completion: nil)
  }
}


extension PhotoCell: PlayerViewDelegate{
  
  func livePlayDidFinish(_ view: PlayerView) {
    if playerView.isHidden == false{
      playerView.isHidden = true
    }
  }
  
}

















