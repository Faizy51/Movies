//
//  Movie.swift
//  Movies
//
//  Created by Faizyy on 02/04/21.
//

import Foundation

struct Result: Codable {
    var Search: [Movie]?
//    var totalResults: Int?
//    var Response: Bool?
}

struct Movie: Codable {
    var imdbID: String?
    var Title: String?
    var Year: String?
    var Poster: String?
}
