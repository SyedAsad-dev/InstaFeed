// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Utils
import Domain
import AVFoundation

public struct FeedsView: View {
    
    @State private var activeVideoIndex = -1
    @State var viewModel: FeedsBasedViewModel
    @StateObject var videoPreloader: VideoPreloader
    public init (viewModel: FeedsBasedViewModel, videoPreloader: VideoPreloader) {
        self.viewModel = viewModel
        _videoPreloader = .init(wrappedValue: videoPreloader)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let containerHeight = geometry.size.height
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(0..<viewModel.posts.count, id: \.self) { index in
                    
                        FullscreenVideoView(geometry: geometry,
                                            post: viewModel.posts[index], player: videoPreloader.players[viewModel.posts[index].id],
                                           
                            isActive: Binding(
                                get: { activeVideoIndex == index },
                                set: { if $0 { activeVideoIndex = index } }
                            )
                        )
                        .frame(height: geometry.size.height)
                        .background(GeometryReader { proxy in
                            Color.clear
                                .preference(key: VideoVisibilityPreferenceKey.self, value: [
                                    VideoVisibility(id: index, visibleHeight: visibleHeight(of: proxy, in: geometry))
                                ])
                        })
                    }
                }
            }
            .onPreferenceChange(VideoVisibilityPreferenceKey.self) { visibilities in
                if let mostVisible = visibilities.max(by: { $0.visibleHeight < $1.visibleHeight }) {
                    if mostVisible.visibleHeight > (containerHeight) * 0.5 {
                        Task { @MainActor in
                            activeVideoIndex = mostVisible.id
                        }
                    }
                }
            }
            
        }.LoadingConfig(show: $viewModel.isLoading)
            .onViewDidLoad {
                viewModel.hitApis()
            }.alert("Warning", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.presentableError)
            }
    }
    
    // Calculate visible height of a video item
    func visibleHeight(of proxy: GeometryProxy, in container: GeometryProxy) -> CGFloat {
        let videoTop = proxy.frame(in: .global).minY
        let videoBottom = proxy.frame(in: .global).maxY
        let containerTop = container.frame(in: .global).minY
        let containerBottom = container.frame(in: .global).maxY
        let visibleTop = max(videoTop, containerTop)
        let visibleBottom = min(videoBottom, containerBottom)
        return max(visibleBottom - visibleTop, 0)
    }
    
}

// MARK: - Preference Key to Track Visibility
struct VideoVisibility: Equatable {
    let id: Int
    let visibleHeight: CGFloat
}

struct VideoVisibilityPreferenceKey: PreferenceKey {
    static let defaultValue: [VideoVisibility] = []
    static func reduce(value: inout [VideoVisibility], nextValue: () -> [VideoVisibility]) {
        value.append(contentsOf: nextValue())
    }
}
