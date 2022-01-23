//
//  MoviesPresenter.swift
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

protocol MoviesPresentationLogic
{
    func presentMovies(response: Movies.GetMovies.Response)
	func selectMovie(response: Movies.SelectMovie.Response)
}

class MoviesPresenter: MoviesPresentationLogic
{
    weak var vc: MoviesDisplayLogic!
    
    func presentMovies(response: Movies.GetMovies.Response) {
		let items = response.movies.map{
			Movies.SharedViewModel.DisplayMovie($0, isSelected: false)
		}
		DispatchQueue.main.async {
			self.vc.displayMovies(viewModel: Movies.GetMovies.ViewModel(items: items, hasNext: response.hasMore, error: response.error))
		}
    }
	
	func selectMovie(response: Movies.SelectMovie.Response) {

		DispatchQueue.main.async {
			self.vc.selectMovie(movie: response.movie)
		}
	}
}
