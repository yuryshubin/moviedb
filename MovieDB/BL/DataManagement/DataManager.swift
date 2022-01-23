//
//  AuthenticationManager.swift
//  MovieDB
//
//  Created by Yury Shubin on 21.01.22.
//

import Foundation

class DataManager
{	
	private var offline: Bool
	private let blContext: BLContext
	private var imageServerConfiguration: ImageServerConfiguration?
		
	init(blContext: BLContext)
	{
		self.offline = false
		self.blContext = blContext
	}
	
	func goOffline() {
		self.offline = true
	}
	
	func configure() async throws
	{
		guard self.imageServerConfiguration == nil else {
			return
		}
		
		do {
			let response = try await NetGetConfigurationOperation().exec()
			self.imageServerConfiguration = ImageServerConfiguration(baseImagePath: response.secure_base_url,
																	 posterSize: response.poster_sizes.last,
																	 backdropSize: response.backdrop_sizes.last)
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
	
	func newContext() -> DataFetchContext {
		return DataFetchContext(offline: self.offline, blContext: self.blContext, imageServerConfiguration: self.imageServerConfiguration)
	}
}
