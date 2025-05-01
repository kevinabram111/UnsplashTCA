//
//  Moya+Extension.swift
//  UnsplashTCA
//
//  Created by Kevin Abram on 30/04/25.
//

import Moya

extension MoyaProvider {
    func asyncRequest(_ target: Target) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
