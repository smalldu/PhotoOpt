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
    if avItem?.status == .readyToPlay {
      return
    }
    if let playerLayer = self.layer as? AVPlayerLayer{
      self.url = url
      avItem = AVPlayerItem(url: url)
      avplayer = AVPlayer(playerItem: avItem)
      playerLayer.player = avplayer
      playerLayer.videoGravity = .resizeAspectFill
      playerLayer.contentsScale = UIScreen.main.scale
    }
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
    guard let item = self.avItem else {
      print("item is nil")
      return
    }
    if item.status == .readyToPlay {
      // 可以播放的状态
      avplayer?.play()
    }else{
      print("状态异常 -- \(item.status) --")
      print(self.url?.absoluteString)
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
