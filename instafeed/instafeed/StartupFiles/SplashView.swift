//
//  ContentView.swift
//  instafeed
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import SwiftUI
import Router

 struct SplashView: View {
    @State private var isActive = false
    var body: some View {
         GeometryReader { geometry in
             ZStack {
                 if isActive {
                     AppNavHandler()
                 } else {
                     Color.black.ignoresSafeArea()
                     Color.black.frame(width: geometry.size.width / 2, height:  geometry.size.height / 2).opacity(0.35).blur(radius: 120)
                     Image("splashlogo")
                         .resizable()
                         .frame(width: geometry.size.width, height: geometry.size.width)
                 }
             }
             .onAppear {
                
                 DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                         withAnimation {
                             isActive = true
                         }
                 }
             }
         }
     }

    
 }
