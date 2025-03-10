//
//  NavigationModifier.swift
//  Router
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import SwiftUI

public struct NavigationModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .navigationDestination(for: Route.self) { $0 }
    }
}

public extension View {
    func navigationsConfig() -> some View {
        self.modifier(NavigationModifier())
    }
}
