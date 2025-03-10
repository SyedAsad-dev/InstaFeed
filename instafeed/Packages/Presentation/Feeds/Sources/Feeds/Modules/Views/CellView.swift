//
//  CellView.swift
//  Feeds
//
//  Created by Rizvi Naqvi on 07/03/2025.
//

import SwiftUI
import Utils
import Domain
import AVKit

// MARK: - Fullscreen Video View
struct FullscreenVideoView: View {
    let geometry: GeometryProxy
    let post: PresentablePost
    let player: AVPlayer?
    @Binding var isActive: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                if let imageName = post.thumbnailURL {
                    KingfisherView(image: imageName).scaledToFill()
                        .frame(width: 50, height: 50).background(.pink).clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50).background(.pink).clipShape(Circle())
                }

                
                Text(post.username).font(.headline)
            }.padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 0))
            switch post.mediaType {
            case .video:
                VideoPlayer(player: player)
                    .aspectRatio(CGFloat(9) / CGFloat(16), contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height / 1.3)
                        .clipped()
                    .onChange(of: isActive) { playing in
                        if playing {
                            player?.seek(to: .zero)
                            player?.play()
                        } else {
                            player?.pause()
                        }
                    }
            case .image:
                if let imageName = post.thumbnailURL {
                    KingfisherView(image: imageName).scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height / 1.3)
                } else {
                    Image(systemName: "emptyleague")
                        .resizable()
                        .frame(width: geometry.size.width, height: geometry.size.height / 1.3)
                }

            }
           
            Text(post.caption)
                .lineLimit(nil)
                .font(.system(size: 15))
                .padding(.leading, 16).padding(.trailing, 16).padding(.bottom, 16)
            Spacer()
            Divider()
            
        }.listRowInsets(EdgeInsets())

    }
    
    

    
}
