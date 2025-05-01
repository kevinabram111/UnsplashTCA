//
//  PhotoListReducer.swift
//  UnsplashTCA
//
//  Created by Kevin Abram on 30/04/25.
//

import Foundation
import ComposableArchitecture
import Moya

enum ViewPhase: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)
}

// MARK: - TCA State
struct PhotoListState: Equatable {
    var photos: [Photo] = []
    var page: Int = 1
    var toastMessage: String? = nil
    var phase: ViewPhase = .idle
    var isPaginating: Bool = false
}

// MARK: - TCA Action
enum PhotoListAction: Equatable {
    case fetchPhotos
    case loadNextPage
    case refresh
    case photosResponse(Result<[Photo], PhotoError>)
    case clearToast
}

enum PhotoError: Error, Equatable {
    case decodingError
    case networkError(String)
}

// MARK: - TCA Reducer
struct PhotoListReducer: Reducer {
    typealias State = PhotoListState
    typealias Action = PhotoListAction
    
    let provider: MoyaProvider<PhotoListAPI>

    func reduce(into state: inout PhotoListState, action: PhotoListAction) -> Effect<PhotoListAction> {
        switch action {
        case .fetchPhotos:
            if state.phase == .idle || state.phase == .failed("") {
                state.phase = .loading
            } else {
                state.isPaginating = true
            }

            // Capture state.page *inside* the Effect.run
            return .run { [page = state.page] send in
                do {
                    let response = try await provider.asyncRequest(.getPhotos(page: page, limit: 20))
                    let photos = try JSONDecoder().decode([Photo].self, from: response.data)
                    await send(.photosResponse(.success(photos)))
                } catch {
                    await send(.photosResponse(.failure(.networkError("Failed to load photos. Pull to refresh."))))
                }
            }

        case .loadNextPage:
            guard !state.isPaginating else { return .none }
            state.page += 1
            return .send(.fetchPhotos)

        case .refresh:
            state.photos = []
            state.page = 1
            state.phase = .loading
            return .send(.fetchPhotos)

        case let .photosResponse(.success(photos)):
            state.photos += photos
            state.isPaginating = false
            state.phase = .loaded
            return .none

        case let .photosResponse(.failure(error)):
            state.isPaginating = false
            state.phase = .failed(error.localizedDescription)
            state.toastMessage = "Failed to load photos. Pull to refresh."
            return .none

        case .clearToast:
            state.toastMessage = nil
            return .none
        }
    }
}
