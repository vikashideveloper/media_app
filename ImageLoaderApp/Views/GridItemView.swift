//
//  GridItemView.swift
//  ImageLoaderApp
//
//  Created by Vikash Kumar on 14/04/24.
//

import SwiftUI

struct GridItemView: View {
    @EnvironmentObject var viewModel: MediaCoverageListViewModel
    @State private var image: Image?
    @State private var isLoading = false
    
    private let media: Media
    private let quality: Int
    private let contentMode: ContentMode
    
    init(media: Media, quality: Int = 20, contentMode: ContentMode = .fill) {
        self.media = media
        self.quality = quality
        self.contentMode = contentMode
    }
    
    var body: some View {
        VStack {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .clipped()
                
            } else if isLoading {
                ProgressView()
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .fill(.clear)
                    .overlay {
                        Text("No Image Found")
                            .fontWeight(.light)
                            .fontWidth(.compressed)
                            .foregroundStyle(.white)
                    }
            }
        }
        .onAppear {
            Task {
                isLoading = true
                if let data = await viewModel.downloadImageFor(media: media, quality: quality) {
                    if let uiimage = UIImage(data: data) {
                        self.image = Image(uiImage: uiimage)
                    }
                }
                isLoading = false
            }
        }
    }
}

#Preview {
    let media = Media(id: "", title: "", thumbnail: Thumbnail(id: "", domain: "", basePath: "", key: "", qualities: []))
    return GridItemView(media: media)
        .environmentObject(MediaCoverageListViewModel.instantiateWithDI())
}
