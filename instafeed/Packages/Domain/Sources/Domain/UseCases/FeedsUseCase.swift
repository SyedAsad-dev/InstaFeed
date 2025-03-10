//
//  FeedsUseCase.swift
//  Domain
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import Foundation
import Utils


public final class FeedsUseCase: FeedsUseCaseProtocol {
    private let feedsRepository: FeedsRepositoryProtocol
    private let videoPreloader: VideoPreloaderProtocol
    
    public init(feedsRepository: FeedsRepositoryProtocol, videoPreloader: VideoPreloaderProtocol) {
        self.feedsRepository = feedsRepository
        self.videoPreloader = videoPreloader
    }
    
    public func execute(page: Int, pageSize: Int) async throws -> PresentablePosts {
        let response = try await feedsRepository.fetchPosts(page: page, pageSize: pageSize)

        guard let posts = response.data?.data else { return [] }
        
        let transformDataModel = transformToPresentablePosts(from: posts)
            
         videoPreloader.preloadVideos(posts: transformDataModel, maxConcurrentPreloads: 3)
        
        return transformDataModel
    }
    
    func transformToPresentablePosts(from posts: [Post]) -> PresentablePosts {
        
        return posts.compactMap { post in
            guard
                let mediaType = post.mediaType,
                let mediaURL = post.mediaURL.map({ URL(string: $0) }),
                let caption = post.caption,
                let thumbnailURL = post.thumbnailURL.map({ URL(string: $0) }),
                let permalink = post.permalink,
                let timestamp = post.timestamp,
                let username = post.username
            else { return nil }
            
            let formattedDate = convertToTimeAndMonthFormat(dateString: timestamp)

            return PresentablePost(
                id: post.id!,
                mediaType: mediaType,
                mediaURL: mediaURL,
                caption: caption,
                thumbnailURL: thumbnailURL,
                permalink: permalink,
                timestamp: formattedDate ?? "",
                username: username
            )
        }
    }


    func convertToTimeAndMonthFormat(dateString: String, dateFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> String? {
        // Initialize the date formatter to parse the input string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        // Convert the string to a Date object
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        // Set up another date formatter to format the date as "HH:mm, MMM dd"
        dateFormatter.dateFormat = "HH:mm, MMM dd"
        
        // Convert the Date back to the desired string format
        return dateFormatter.string(from: date)
    }


}
