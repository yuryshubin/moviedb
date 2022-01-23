//
//  MoviesModels.swift
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

enum Movies
{	
	struct SharedViewModel
	{
		class DisplayMovie
		{
			let item: BLMovie
			var isSelected: Bool

			init(_ item: BLMovie, isSelected: Bool)
			{
				self.item = item
				self.isSelected = isSelected
			}
			
			var title: String {
				return self.item.title
			}
			
			var overview: String? {
				return self.item.overview
			}
			
			var imageURL: URL? {
				return self.item.imageURL
			}
		}
	}
	
	// MARK: - GetMovies
	enum GetMovies
	{
		struct Request{}
		
		struct Response
		{
			let movies: [BLMovie]
			let hasMore: Bool
			let error: String?
		}
		
		struct ViewModel
		{
			let items: [SharedViewModel.DisplayMovie]
			let hasNext: Bool
			var error: String?
		}
	}
	
	// MARK: - Select Movie
	enum SelectMovie
	{
		struct Request{
			let movie: SharedViewModel.DisplayMovie
		}
		
		struct Response{
			let movie: SharedViewModel.DisplayMovie
		}
	}
}