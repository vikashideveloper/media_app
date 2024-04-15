//
//  ImageLoaderAppApp.swift
//  ImageLoaderApp
//
//  Created by Vikash Kumar on 14/04/24.
//

import SwiftUI
import SwiftData

@main
struct ImageLoaderAppApp: App {
    var body: some Scene {
        WindowGroup {
            MediaCoverageListView()
                .environmentObject(MediaCoverageListViewModel.instantiateWithDI())
        }
    }
}
