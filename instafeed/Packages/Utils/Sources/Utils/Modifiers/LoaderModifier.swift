//
//  LoaderModifier.swift
//  Utils
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import SwiftUI

public struct LoaderModifier: ViewModifier {
    @Binding var showLoader: Bool
    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(showLoader)
            
            if showLoader {
                
                ProgressView("")
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .tint(.black)
            }
        }
        .animation(.linear(duration: 0.5), value: showLoader)
    }
}

extension View {
    public func LoadingConfig(show: Binding<Bool>) -> some View {
        self.modifier(LoaderModifier(showLoader: show))
    }
}
