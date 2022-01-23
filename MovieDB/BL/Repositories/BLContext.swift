//
//  BLContext.swift
//  MovieDB
//
//  Created by Yury Shubin on 22.01.22.
//

import Foundation

class BLContext {
	let movieRepository: MovieRepository
	let databaseContext: DBContext
	
	init?() {
		
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
		let dbFileURL = documentsDirectory.appendingPathComponent("db/db")
		
		do {
			try DBManager.setup(dbFileURL: dbFileURL)
		} catch {
			return nil
		}
		
		self.databaseContext = DBContext()
		self.movieRepository = MovieRepository()
		self.movieRepository.setContext(self.databaseContext.ctx)
	}
	
	func save() {
		self.databaseContext.save()
	}
}
