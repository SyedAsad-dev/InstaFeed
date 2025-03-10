//
//  FeedsViewContainer.swift
//  Router
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import SwiftUI
import Feeds
import Utils
import Domain

public typealias MainDependancyContainer = FeedsViewContainer

public protocol FeedsViewContainer {
    @ViewBuilder
    func feedsViewContainer() async -> FeedsView
}

extension FeedsViewContainer {
    @MainActor
    public func feedsViewContainer() -> FeedsView {
        let videoPreloader = VideoPreloader()
        return FeedsView(viewModel: VMCreator.FeedViewModel(videoPreloader: videoPreloader), videoPreloader: videoPreloader)
    }
}

