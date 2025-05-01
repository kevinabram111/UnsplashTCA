//
//  PhotoListAPI.swift
//  UnsplashTCA
//
//  Created by Kevin Abram on 30/04/25.
//

import Foundation
import Moya

enum PhotoListAPI {
    case getPhotos(page: Int, limit: Int)
}

extension PhotoListAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://picsum.photos")!
    }

    var path: String {
        switch self {
        case .getPhotos:
            return "/v2/list"
        }
    }

    var method: Moya.Method {
        .get
    }

    var task: Task {
        switch self {
        case let .getPhotos(page, limit):
            return .requestParameters(parameters: [
                "page": page,
                "limit": limit
            ], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    var sampleData: Data {
        Data()
    }
}
