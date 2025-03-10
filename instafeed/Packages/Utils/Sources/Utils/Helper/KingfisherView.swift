//
//  KingfisherView.swift
//  Utils
//
//  Created by Rizvi Naqvi on 08/03/2025.
//

import SwiftUI
import Kingfisher

public struct KingfisherView: View {
    let image: URL?
    public init(image: URL?) {
        self.image = image
    }
    public var body: some View {
       
            KFImage(image)
                .resizable()
                
        
    }
}
