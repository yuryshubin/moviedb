//
//  MovieRepository.swift
//  MovieDB
//
//  Created by Yury Shubin on 21.01.22.
//

import Foundation
import CoreData

class MovieRepository
{
	private var movies: [Int32: BLMovie]
	private var ctx: NSManagedObjectContext!
		
	init() {
		self.movies = [:]
	}
	
	func setContext(_ context: NSManagedObjectContext){
		self.ctx = context
	}
	
	private func make(with rlMovie: RLMovie) -> BLMovie
	{
		let movie = BLMovie(id: rlMovie.id,
							title: rlMovie.title!,
							popularity: rlMovie.popularity,
							overview: rlMovie.overview,
							imageURL: rlMovie.poster,
							backdropImageURL: rlMovie.backdrop)
		movie.objectID = rlMovie.objectID
		self.movies[movie.id] = movie
		return movie
	}
	
	func upsert(movies: [BLMovie]) {
		
		let ids = movies.map{ $0.id }
		let predicate = NSPredicate(format: "id IN %@", ids)
		let rlMovies = RLMovie.mr_findAll(with: predicate, in: self.ctx) as! [RLMovie]
		
		let rlIds = rlMovies.map{ $0.id }
		
		let toInsert = Set(ids).subtracting(rlIds)
		let toUpdate = Set(ids).subtracting(toInsert)
		
		let rlMoviesSet = Set(rlMovies)
		
		let moviesToInsert = movies.filter{ toInsert.contains($0.id) }
		let moviesToUpdate = movies.filter{ movie in
			let contains = toUpdate.contains(movie.id)
			if contains {
				movie.objectID = rlMoviesSet.first{ $0.id == movie.id }?.objectID
			}
			return contains
		}
		
		moviesToInsert.forEach{ self.insert($0) }
		moviesToUpdate.forEach{ self.update($0) }
	}

	func insert(_ movie: BLMovie){
		self.ctx.performAndWait
		{
			let rlMovie = RLMovie.mr_createEntity(in: self.ctx)!
			try! self.ctx.obtainPermanentIDs(for: [rlMovie])
			
			rlMovie.id = movie.id
			rlMovie.title = movie.title
			rlMovie.popularity = movie.popularity
			rlMovie.overview = movie.overview
			rlMovie.poster = movie.imageURL
			rlMovie.backdrop = movie.backdropImageURL
							
			movie.objectID = rlMovie.objectID
			self.movies[movie.id] = movie
		}
	}
	
	@discardableResult
	open func update(_ movie: BLMovie) -> Bool
	{
		var rlMovie: RLMovie?
		self.ctx.performAndWait
		{
			rlMovie = (self.ctx.object(with: movie.objectID!) as? RLMovie)
			guard let rlMovie = rlMovie else
			{ return }
			
			rlMovie.id = movie.id
			rlMovie.title = movie.title
			rlMovie.popularity = movie.popularity
			rlMovie.overview = movie.overview
			rlMovie.poster = movie.imageURL
			rlMovie.backdrop = movie.backdropImageURL
							
			movie.objectID = rlMovie.objectID
		}
		return rlMovie != nil
	}
	
	func delete(_ movie: BLMovie) -> Bool{
		var rlMovie: RLMovie?
		self.ctx.performAndWait
		{
			rlMovie = (self.ctx.object(with: movie.objectID!) as? RLMovie)
			guard rlMovie != nil else
			{ return }
				
			rlMovie!.mr_deleteEntity(in: self.ctx)
			self.movies.removeValue(forKey: movie.id)
		}
		return rlMovie != nil
	}
	
	func find(id: Int32) -> BLMovie? {
		if let movie = self.movies[id] {
			return movie
		}
		
		let predicate = NSPredicate(format: "id == %lld", id)
		var rlMovie: RLMovie?
		self.ctx.performAndWait {
			rlMovie = RLMovie.mr_findFirst(with: predicate, in: self.ctx)
		}
		
		guard rlMovie != nil else {
			return nil
		}
		return self.make(with: rlMovie!)
	}
	
	func all(page: UInt, pageSize: UInt) -> [BLMovie] {
		
		var rlMovies: [RLMovie] = []
		
		self.ctx.performAndWait {
			let fetchRequest = RLMovie.mr_createFetchRequest(in: self.ctx)
			fetchRequest.fetchOffset = Int(page - 1) * Int(pageSize)
			fetchRequest.fetchLimit = Int(pageSize)
			fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false)]
			rlMovies = RLMovie.mr_execute(fetchRequest, in: self.ctx) as! [RLMovie]
		}
		return rlMovies.map{ self.make(with: $0) }
	}

}
