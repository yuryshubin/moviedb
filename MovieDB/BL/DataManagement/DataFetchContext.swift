//
//  DataFetchContext.swift
//  MovieDB
//
//  Created by Yury Shubin on 22.01.22.
//

import Foundation

class DataFetchContext
{
	private let blContext: BLContext
	private let offline: Bool
	private(set) var hasMoreData: Bool
	private var page: UInt
	private let offlinePageSize: UInt
	private let imageServerConfiguration: ImageServerConfiguration?
	
	private(set) var movies: [BLMovie]

	init(offline: Bool, blContext: BLContext, imageServerConfiguration: ImageServerConfiguration?) {
		
		self.offline = offline
		self.blContext = blContext
		self.hasMoreData = true
		self.page = 1
		self.offlinePageSize = 20
		self.imageServerConfiguration = imageServerConfiguration
		self.movies = []
	}
	
	func next() async throws -> Bool {
		guard self.hasMoreData else
		{ return false }
		
		if self.offline {
			let movies = await self.loadNetLocal(page: self.page)
			self.page += 1
			self.movies.append(contentsOf: movies)
			return true
		} else {
			let movies = try await self.loadNextNetwork(page: self.page)
			self.page += 1
			self.movies.append(contentsOf: movies)
			return true
		}
	}
	
	private func loadNetLocal(page: UInt) async -> [BLMovie] {
		
		let movies = self.blContext.movieRepository.all(page: self.page, pageSize: self.offlinePageSize)
		self.hasMoreData = !movies.isEmpty
		return movies
	}
	
	private func loadNextNetwork(page: UInt) async throws -> [BLMovie] {
		
		guard let serverConfiguration = self.imageServerConfiguration else {
			throw BLError.configuration
		}
		
		do {
			let response = try await NetFetchMoviesOperation(page: page).exec()
			self.hasMoreData = page < response.total_pages
			
			let movies: [BLMovie] = response.results.map{
					
				var imageURL: URL?
				if let path = $0.poster_path
				{
					imageURL = serverConfiguration.buildPosterURL(for: path)
				}
				var backdropImageURL: URL?
				if let path = $0.backdrop_path
				{
					backdropImageURL = serverConfiguration.buildBackdropURL(for: path)
				}
				return BLMovie(id: $0.id,
							   title: $0.title,
							   popularity: $0.popularity,
							   overview: $0.overview,
							   imageURL: imageURL,
							   backdropImageURL: backdropImageURL)
			}
			
			self.blContext.movieRepository.upsert(movies: movies)
			self.blContext.save()
			return movies
			
		} catch let error {
			guard let error = error as? NetworkError else {
				throw BLError.unknown()
			}
			
			switch error {
			case .application:
				throw BLError.logic(error)
			case .server, .client:
				throw BLError.dataNotAvailable(error)
			case .parse:
				throw BLError.dataCorrupted(error)
			case .unknown:
				throw BLError.unknown(error)
			}
		}
	}
}
