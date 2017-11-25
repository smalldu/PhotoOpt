//
//  PlayerView.swift
//  PhotoOpt
//
//  Created by duzhe on 2017/11/25.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
import AVFoundation

protocol PlayerViewDelegate: class {
  func livePlayDidFinish(_ view: PlayerView)
}


class Player {
  static let shared = Player()
  var maxCount: Int = 5 // 最大12个元素
  var currentIndex: Int = 0
  var playerPool: [AVPlayer] = []
  
  func player()->AVPlayer{
    if playerPool.count < maxCount {
      let avplayer = AVPlayer()
      playerPool.append(avplayer)
    }
    let index = currentIndex
    if currentIndex == maxCount - 1{
      currentIndex = 0
    }
    currentIndex += 1
    return playerPool[index]
  }
  
  
}

var count = 0
class PlayerView: UIView {
  
  weak var delegate: PlayerViewDelegate?
  var avplayer: AVPlayer?
  var avItem: AVPlayerItem?
  override class var layerClass: AnyClass {
    return AVPlayerLayer.self
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    prepareView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepareView()
  }
  
  func prepareView(){
    NotificationCenter.default.addObserver(self, selector: #selector(didFinishPlay(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime , object: avItem)
  }
  var url: URL?
  
  func configWithURL(_ url: URL) {
//    if url.absoluteString == (self.url?.absoluteString ?? ""){
//      return
//    }
    self.url = url
    self.avItem = AVPlayerItem(url: url)
//    if let playerLayer = self.layer as? AVPlayerLayer{
//      DispatchQueue.global(qos: .background).async {
//        self.url = url
//        self.avItem = AVPlayerItem(url: url)
//        self.avplayer = Player.shared.player()
//        self.avplayer?.replaceCurrentItem(with: self.avItem)
//        DispatchQueue.main.async {
//          playerLayer.player = self.avplayer
//          playerLayer.videoGravity = .resizeAspectFill
//          playerLayer.contentsScale = UIScreen.main.scale
//        }
//      }
//    }
  }
  
  @objc func didFinishPlay(_ notification: NSNotification){
    if let item = notification.object as? AVPlayerItem{
      if item == self.avItem{
        item.seek(to: kCMTimeZero)
        print("播放结束")
        delegate?.livePlayDidFinish(self)
      }
    }
  }
  
  func play(){
    if let playerLayer = self.layer as? AVPlayerLayer{
      if self.avplayer == nil {
        self.avplayer = Player.shared.player()
      }
      if self.avplayer?.currentItem != avItem {
        self.avplayer?.replaceCurrentItem(with: avItem!)
      }
      CATransaction.begin()
      CATransaction.setDisableActions(true)
      playerLayer.player = avplayer
      playerLayer.videoGravity = .resizeAspectFill
      playerLayer.contentsScale = UIScreen.main.scale
      CATransaction.commit()
      
      avplayer?.play()
    }
  }
  
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
