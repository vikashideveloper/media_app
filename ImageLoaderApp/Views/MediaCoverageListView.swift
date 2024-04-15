//
//  MediaCoverageListView.swift
//  ImageLoaderApp
//
//  Created by Vikash Kumar on 14/04/24.
//

import SwiftUI

struct MediaCoverageListView: View {
    @EnvironmentObject var viewModel: MediaCoverageListViewModel
    
    private let flexibleColumn = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5),
    ]
    
    private let gridItemSpacing: CGFloat = 5
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    if viewModel.isLoading {
                        VStack {
                            ProgressView()
                            Text("Fetching...")
                        }
                    }
                    if let error = viewModel.error {
                        ErrorView(error: error, onClose: {
                            viewModel.clearError()
                        }, onRetry: {
                            Task {
                                await viewModel.fetchMediaCoverages()
                            }
                        })
                    }
                    
                    LazyVGrid(columns: flexibleColumn, spacing:gridItemSpacing) {
                        ForEach(viewModel.medias) { media in
                            NavigationLink(value: media) {
                                GridItemView(media: media)
                                    .frame(height: (geometry.size.width-gridItemSpacing*4)/3)
                            }
                        }
                    }
                    .padding(.horizontal, gridItemSpacing)
                    .navigationTitle("Media Coverage")
                    .navigationDestination(for: Media.self) { media in
                        GridItemView(media: media, quality: 40, contentMode: .fit)
                    }
                }
            }
            .background(.black.opacity(0.1))
        }
        .onAppear {
            Task {
                await viewModel.fetchMediaCoverages()
            }
        }
    }
}

#Preview {
    return MediaCoverageListView()
        .environmentObject(MediaCoverageListViewModel.instantiateWithDI())
}
