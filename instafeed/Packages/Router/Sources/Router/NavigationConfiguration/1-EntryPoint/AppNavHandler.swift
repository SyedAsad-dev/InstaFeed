//
//  AppNavHandler.swift
//  Router
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import SwiftUI

public struct AppNavHandler: View {
    @StateObject private var viewModel = AppNavHandlerViewModel()

    public init() {}
    
    public var body: some View {
        
        let firstView: AppRoute = .FeedsScreen
        NavigationStack(path: $viewModel.appRoutes) {
            firstView
                .navigationsConfig()
        }
    }
}
