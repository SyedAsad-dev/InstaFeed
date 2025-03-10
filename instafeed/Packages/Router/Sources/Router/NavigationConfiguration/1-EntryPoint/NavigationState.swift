//
//  NavigationState.swift
//  Router
//
//  Created by Rizvi Naqvi on 07/03/2025.
//
import SwiftUI

@MainActor
public final class AppNavHandlerViewModel: ObservableObject {
    
    @Published public var appRoutes: [Route] = []
   
}
