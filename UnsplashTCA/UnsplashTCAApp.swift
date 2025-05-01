//
//  UnsplashTCAApp.swift
//  UnsplashTCA
//
//  Created by Kevin Abram on 30/04/25.
//

import SwiftUI
import ComposableArchitecture
import Moya

@main
struct UnsplashTCAApp: App {
    var body: some Scene {
        WindowGroup {
            PhotoListView(
                store: Store(
                    initialState: PhotoListState(),
                    reducer: {
                        PhotoListReducer(provider: MoyaProvider<PhotoListAPI>())
                    }
                )
            )
        }
    }
}
