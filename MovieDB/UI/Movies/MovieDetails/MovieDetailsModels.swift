//
//  MovieDetailsModels.swift
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

enum MovieDetails
{
	struct SharedViewModel
	{
		class DisplayMovie
		{
			let item: BLMovie

			init(_ item: BLMovie)
			{
				self.item = item
			}
			
			var title: String {
				return self.item.title
			}
			
			var overview: String? {
				return self.item.overview
			}
			
			var backdropImageURL: URL? {
				return self.item.backdropImageURL
			}
		}
	}
	
	// MARK: Use cases
	
	// MARK: - Show
	enum Show
	{
		struct Request{}
		
		struct Response
		{
			let movie: SharedViewModel.DisplayMovie
		}
		
		struct ViewModel
		{
			let item: SharedViewModel.DisplayMovie
		}
	}
}
