//
//  VideoPreloader.swift
//  Domain
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import AVFoundation
import Utils

// MARK: - Video Preloading Logic
public protocol VideoPreloaderProtocol: Sendable {
    var players: [String: AVPlayer] { get set }
    func preloadVideos(posts: PresentablePosts, maxConcurrentPreloads: Int)
}

public class VideoPreloader: ObservableObject, VideoPreloaderProtocol, @unchecked Sendable {
    
    @Published  public var players = [String: AVPlayer]()
    private var accessOrder = [String]() // For LRU cache
    private let cacheLimit = 20
    
    public init() {
    }
    
    public func preloadVideos(posts: PresentablePosts, maxConcurrentPreloads: Int = 3)   {
        
        var firstfullyLoadedVideoIndex: String = ""
        for post in posts where post.mediaType == .video {
            firstfullyLoadedVideoIndex = post.id
          if let url =  post.mediaURL  {
                  DispatchQueue.main.async { [weak self] in
                      self?.players[post.id] = AVPlayer(url: url)
                  }
                  break
            }
        }
        
        Task.detached{
            await withTaskGroup(of: Void.self) { group in
                for (index,post) in posts.enumerated() where post.id != firstfullyLoadedVideoIndex {
                    if case .video = post.mediaType, let url = post.mediaURL  {
                        if index >= maxConcurrentPreloads {
                            await group.next()
                        }
                        group.addTask { [weak self] in
                            self?.preloadPartialVideo(key: post.id, url: url, preloadPercentage: 0.1)
                        }
                    }
                }
            }
        }
        
    }
    
    private func preloadPartialVideo(key: String, url: URL, preloadPercentage: Double = 0.1) {
        let asset = AVURLAsset(url: url)
        let keys = ["playable"]
        
        asset.loadValuesAsynchronously(forKeys: keys) { [weak self]  in
       
                let playerItem = AVPlayerItem(asset: asset)
                let player = AVPlayer(playerItem: playerItem)
                
                let preloadTime: Double
                    preloadTime = max(1, min(asset.duration.seconds * preloadPercentage, 10))
         
                if preloadTime.isFinite && preloadTime > 0 {
                    let tenPercent = CMTime(seconds: preloadTime * 0.1, preferredTimescale: 600)
                    player.seek(to: tenPercent) { [weak self] _ in
                        // Preload done, store player
                        DispatchQueue.main.async { [weak self] in
                            self?.players[key] = player
                            self?.updateAccessOrder(for: key)
                            self?.manageCacheSize()
                           
                        }
                        
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                    self?.players[key] = player// Fallback in case duration is invalid
                }
            }
        }
    }
    
    /// Manage cache size with LRU eviction
    private func manageCacheSize() {
        while players.count > cacheLimit {
            if let oldestKey = accessOrder.first {
                players[oldestKey]?.pause()
                players[oldestKey]?.replaceCurrentItem(with: nil)
                players.removeValue(forKey: oldestKey)
                accessOrder.removeFirst()
            }
        }
    }
    
    /// Update access order for LRU cache
      private func updateAccessOrder(for key: String) {
          accessOrder.removeAll { $0 == key }
          accessOrder.append(key)
      }

}
