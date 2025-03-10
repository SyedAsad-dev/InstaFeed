//
//  AppRouters.swift
//  Router
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import Foundation
import SwiftUI
import Domain
import Utils

public protocol PartialCaseIterable {
    static var iterableCases: [Self] { get }
}

public enum AppRoute: Hashable, Identifiable {
    public var id: AppRoute { self }

    case FeedsScreen
    

    public static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        switch (lhs, rhs) {
        case (.FeedsScreen, .FeedsScreen):
            return true
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .FeedsScreen:
            hasher.combine(0)
        }
    }
}

extension AppRoute: View, MainDependancyContainer {
    @ViewBuilder
    public var body: some View {
        switch self {
        case .FeedsScreen:
            feedsViewContainer()
        }
    }
}
