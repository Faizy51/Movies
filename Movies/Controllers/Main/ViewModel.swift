//
//  ViewModel.swift
//  Movies
//
//  Created by Faizyy on 02/04/21.
//

import Foundation

protocol ViewModel {
    var movies: [Movie]? { get set }
    var isPaginating: Bool { get set }
    
    var didFetchMoviesSucceed: (()->Void)? { get set }
    var didFetchMoviesFail: ((Error?)->Void)? { get set }
    
    func fetchMovies(for searchText: String?, pageNumber: Int)
    func getMovie(at index: Int) -> Movie
}

class ViewModelImplementation: ViewModel {
    var didFetchMoviesSucceed: (() -> Void)?
    var didFetchMoviesFail: ((Error?) -> Void)?
    var isPaginating: Bool = false
    
    var movies: [Movie]?
    var movieService = NetworkManager()
    
    func fetchMovies(for searchText: String?, pageNumber: Int) {
        self.movieService.downloadMovies(for: searchText, pageNumber: pageNumber) { result in
            if self.isPaginating {
                self.movies?.append(contentsOf: result.Search ?? [])
            } else {
                self.movies = result.Search ?? []
            }
            self.didFetchMoviesSucceed?()
        } failure: { error in
            self.didFetchMoviesFail?(error)
        }
    }
    
    func getMovie(at index: Int) -> Movie {
        guard let movieCount = self.movies?.count, index < movieCount, let movie = self.movies?[index] else {
            fatalError("Movie index out of range. Please check the datasource count.")
        }
        return movie
    }
    
//    func fetchImage(for urlString: String, success: @escaping (Data)->Void, failure: @escaping ()->Void ) {
//        self.movieService.downloadImage(for: urlString, success: success, failure: failure)
//    }
    
}
