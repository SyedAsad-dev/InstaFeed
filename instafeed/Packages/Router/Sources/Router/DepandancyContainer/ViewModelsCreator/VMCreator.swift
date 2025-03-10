//
//  VMCreator.swift
//  Router
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import Foundation
import Feeds
import Domain
import Data
import Utils


@MainActor
public enum VMCreator {
    
    static func FeedViewModel(videoPreloader: VideoPreloaderProtocol) -> FeedsViewModel {
        let feedsRepo = FeedsRepository()
        let useCase = FeedsUseCase(feedsRepository: feedsRepo, videoPreloader: videoPreloader)
        return FeedsViewModel(feedsLoader:useCase)
    }
    
    
    
}
