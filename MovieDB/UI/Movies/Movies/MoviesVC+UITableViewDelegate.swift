//
//  MoviesVC+UITableViewDelegate.swift
//  MovieDB
//
//  Created by Yury Shubin on 23.01.22.
//

import Foundation
import UIKit

extension MoviesVC: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.interactor.exec(Movies.SelectMovie.Request(movie: self.viewModel!.items[indexPath.row]))
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		if (self.viewModel!.items.count - 1) == indexPath.row/* && self.isLoading*/ {
			self.interactor.exec(Movies.GetMovies.Request())
		}
	}
}
