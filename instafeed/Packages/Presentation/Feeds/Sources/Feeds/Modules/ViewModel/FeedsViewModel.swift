//
//  FeedsViewModel.swift
//  Feeds
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import Foundation
import Utils
import Domain
import SwiftUI
import AVFoundation

@MainActor
public protocol FeedsBasedViewModel {
    var dataStatus: DataState? { get set }
    var isLoading: Bool { get set }
    var showAlert: Bool { get set }
    var posts: PresentablePosts { get set }
    var presentableError: String { get set }
    func hitApis()
}

@Observable
public class FeedsViewModel: BaseViewModel, FeedsBasedViewModel {
    nonisolated let feedsLoader: FeedsUseCaseProtocol
    
     public var posts: PresentablePosts = []
       private var currentPage = 0
       private let pageSize = 10
       private let preloadThreshold = 8
    

    
    public init(
        feedsLoader: FeedsUseCaseProtocol
    ) {
        self.feedsLoader = feedsLoader
    }
    public func hitApis() {
        dataStatus = .success(.loading)
        Task.detached { [weak self] in
            guard let self else { return }
            await loadMorePosts()
        }
    }

}

extension FeedsViewModel {

     func loadMorePosts() async {
         Task {
             currentPage += 1
             do {
                 let newPosts = try await feedsLoader.execute(page: currentPage, pageSize: pageSize)
                 posts.append(contentsOf: newPosts)
                 dataStatus = .success(.finished(.success))
             } catch let error as AnyAppError {
                 dataStatus = .failure(error)
             } catch {
                 dataStatus = .failure(.init(message: error.localizedDescription))
             }
         }
     }
}
