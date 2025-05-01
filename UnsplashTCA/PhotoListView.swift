//
//  ContentView.swift
//  UnsplashTCA
//
//  Created by Kevin Abram on 30/04/25.
//

import SwiftUI
import ComposableArchitecture
import Moya
import Network
import Kingfisher

struct PhotoListView: View {
    let store: StoreOf<PhotoListReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                List {
                    switch viewStore.phase {
                    case .idle, .loading:
                        ForEach(0..<5, id: \.self) { _ in
                            PhotoListLoadingView()
                        }

                    case .loaded:
                        ForEach(viewStore.photos) { photo in
                            VStack(alignment: .leading) {
                                if let url = URL(string: photo.url) {
                                    Link(destination: url) {
                                        KFImage(URL(string: photo.download_url))
                                            .setProcessor(
                                                    DownsamplingImageProcessor(size: CGSize(width: UIScreen.main.bounds.width, height: 200))
                                                )
                                            .resizable()
                                            .fade(duration: 0.3)
                                            .cacheMemoryOnly()
                                            .placeholder {
                                                Rectangle()
                                                    .fill(Color.gray.opacity(0.3))
                                                    .frame(height: 200)
                                                    .cornerRadius(8)
                                                    .shimmer()
                                            }
                                            .cancelOnDisappear(true)
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 200)
                                            .clipped()
                                    }
                                } else {
                                    KFImage(URL(string: photo.download_url))
                                        .setProcessor(
                                                DownsamplingImageProcessor(size: CGSize(width: UIScreen.main.bounds.width, height: 200))
                                            )
                                        .resizable()
                                        .fade(duration: 0.3)
                                        .cacheMemoryOnly()
                                        .placeholder {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(height: 200)
                                                .cornerRadius(8)
                                                .shimmer()
                                        }
                                        .cancelOnDisappear(true)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 200)
                                        .clipped()
                                }

                                Text(photo.author)
                                    .font(.headline)
                            }
                            .onAppear {
                                if photo == viewStore.photos.last {
                                    viewStore.send(.loadNextPage)
                                }
                            }
                        }

                        if viewStore.isPaginating {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                        }

                    case let .failed(error):
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .navigationTitle("Unsplash Photos")
                .onAppear {
                    if viewStore.photos.isEmpty {
                        viewStore.send(.fetchPhotos)
                    }
                }
                .refreshable {
                    viewStore.send(.refresh)
                }
            }
        }
    }
}

struct AlertMessage: Identifiable {
    var id: String { message }
    let message: String
}
