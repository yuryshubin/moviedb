//
//  MoviesInteractor.swift
//  MovieDB
//
//  Created by Yury Shubin on 22.01.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MoviesBusinessLogic
{
	func exec(_ request: Movies.GetMovies.Request)
	func exec(_ request: Movies.SelectMovie.Request)
}

protocol MoviesDataStore
{
	var selectedMovie: BLMovie? { get set }
}

class MoviesInteractor: MoviesBusinessLogic, MoviesDataStore
{
	var selectedMovie: BLMovie?
	
    var presenter: MoviesPresentationLogic?
	private let context: DataFetchContext
	
	init() {
		self.context = Model.default.dataManager.newContext()
	}
    
	func exec(_ request: Movies.GetMovies.Request) {
		Task
		{
			do {
				let hasMore = try await self.context.next()
				let response = Movies.GetMovies.Response(movies: self.context.movies, hasMore: hasMore, error: nil)
				self.presenter?.presentMovies(response: response)
			} catch let error {
				let response = Movies.GetMovies.Response(movies: [], hasMore: false, error: error.localizedDescription)
				self.presenter?.presentMovies(response: response)
			}
		}
	}
	
	func exec(_ request: Movies.SelectMovie.Request) {
		self.selectedMovie = request.movie.item
		self.presenter?.selectMovie(response: Movies.SelectMovie.Response(movie: request.movie))
	}
}
