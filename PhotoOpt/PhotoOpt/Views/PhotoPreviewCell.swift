//
//  PhotoPreviewCell.swift
//  PhotoOpt
//
//  Created by duzhe on 2017/11/23.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

protocol PhotoPreviewCellDelegate: class {
  func photoPreviewDidToggle(_ cell: PhotoPreviewCell)
}

class PhotoPreviewCell: UICollectionViewCell {
  static let reuseID = "\(PhotoPreviewCell.self)"
  var representedAssetIdentifier: String = ""
  weak var delegate: PhotoPreviewCellDelegate?
  
  @IBOutlet weak var content: UIImageView!
  @IBOutlet weak var selectBtn: UIButton!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var playerView: PlayerView!
  @IBOutlet weak var liveButton: UIButton!
  
  var type: PhotoType = .normal {
    didSet{
      liveButton.isHidden = type != .live
      if type != .live{
        playerView.isHidden = true
      }
//      if type == .normal {
//        flag.isHidden = true
//      } else {
//        flag.isHidden = false
//        flag.text = type.rawValue
//      }
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
  var movURL: URL? {
    didSet{
      if let url = movURL{
        playerView.configWithURL(url)
      }
    }
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    playerView.isHidden = true
    playerView.isFillContent = false
    scrollView.maximumZoomScale = 3.0
    scrollView.minimumZoomScale = 1.0
    scrollView.delegate = self
    let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapImg))
    doubleTap.numberOfTouchesRequired = 1
    doubleTap.numberOfTapsRequired = 2
    self.content.addGestureRecognizer(doubleTap)
    self.content.isUserInteractionEnabled = true
    
    selectBtn.addTarget(self, action: #selector(selectButtonClick), for: .touchUpInside)
    liveButton.addTarget(self, action: #selector(playLive), for: .touchUpInside)
    playerView.delegate = self
  }
  
  @objc func doubleTapImg(){
    if scrollView.zoomScale == 1.0 {
      UIView.animate(withDuration: 0.5, animations: {
        self.scrollView.zoomScale = 3.0
      })
    }else{
      UIView.animate(withDuration: 0.5, animations: {
        self.scrollView.zoomScale = 1.0
      })
    }
  }
  
  @objc func selectButtonClick(){
    delegate?.photoPreviewDidToggle(self)
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


extension PhotoPreviewCell: UIScrollViewDelegate {
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return self.content
  }

}





extension PhotoPreviewCell: PlayerViewDelegate{
  
  func livePlayDidFinish(_ view: PlayerView) {
    if playerView.isHidden == false{
      liveButton.isHidden = false
      playerView.isHidden = true
    }
  }
  func livePlayDidStop(_ view: PlayerView) {
    if playerView.isHidden == false{
      liveButton.isHidden = false
      playerView.isHidden = true
    }
  }
  func livePlayDidBegin(_ view: PlayerView) {
    liveButton.isHidden = true
    playerView.isHidden = false
  }
}










