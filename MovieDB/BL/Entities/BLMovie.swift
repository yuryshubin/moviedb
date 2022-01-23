//
//  BLMovie.swift
//  MovieDB
//
//  Created by Yury Shubin on 21.01.22.
//

import Foundation
import CoreData
import UIKit

class BLMovie: Hashable
{
	var objectID: NSManagedObjectID?
	let id: Int32
	let title: String
	let popularity: Float
	let overview: String?
	let imageURL: URL?
	let backdropImageURL: URL?
	
	init(id: Int32, title: String, popularity: Float, overview: String?, imageURL: URL?, backdropImageURL: URL?)
	{
		self.id = id
		self.title = title
		self.popularity = popularity
		self.overview = overview
		self.imageURL = imageURL
		self.backdropImageURL = backdropImageURL
	}
	
	static func == (lhs: BLMovie, rhs: BLMovie) -> Bool {
		return lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
	}
}
