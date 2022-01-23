//
//  ImageServerConfiguration.swift
//  MovieDB
//
//  Created by Yury Shubin on 23.01.22.
//

import Foundation

class ImageServerConfiguration {
	
	private let baseImagePath: String
	private let posterSize: String
	private let backdropSize: String
		
	init?(baseImagePath: String, posterSize: String?, backdropSize: String?) {
		
		guard let posterSize = posterSize,
			  let backdropSize = backdropSize else {
				  return nil
		  }
		
		self.baseImagePath = baseImagePath
		self.posterSize = posterSize
		self.backdropSize = backdropSize
	}
	
	func buildPosterURL(for path: String) -> URL? {
		return URL(string: "\(self.baseImagePath)\(self.posterSize)\(path)")
	}
	
	func buildBackdropURL(for path: String) -> URL? {
		return URL(string: "\(self.baseImagePath)\(self.backdropSize)\(path)")
	}
}
