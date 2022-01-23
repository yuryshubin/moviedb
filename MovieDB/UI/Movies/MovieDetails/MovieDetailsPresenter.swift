//
//  MovieDetailsPresenter.swift
//  MovieDB
//
//  Created by Yury Shubin on 23.01.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MovieDetailsPresentationLogic{
	func presentMovie(response: MovieDetails.Show.Response)
}

class MovieDetailsPresenter: MovieDetailsPresentationLogic
{
	func presentMovie(response: MovieDetails.Show.Response) {
		self.vc.showMovie(response.movie)
	}
	
    weak var vc: MovieDetailsDisplayLogic!    
}