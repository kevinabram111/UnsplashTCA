//
//  PhotoListModel.swift
//  UnsplashTCA
//
//  Created by Kevin Abram on 30/04/25.
//

import Foundation

struct Photo: Equatable, Identifiable, Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
}
