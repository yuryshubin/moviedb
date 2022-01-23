//
//  NetFetchMoviesOperation.swift
//  MovieDB
//
//  Created by Yury Shubin on 22.01.22.
//

import Foundation

class NetFetchMoviesOperation
{
	private let page: UInt
	
	init(page: UInt) {
		self.page = page
	}
	
	func exec() async throws -> NetSearchMoviesResponse {
		guard var urlComponents = URLComponents(string: NetworkContext.baseURL) else {
			throw NetworkError.application
		}

		urlComponents.path += "/discover/movie"
		urlComponents.queryItems = [
			URLQueryItem(name: "page", value: "\(self.page)"),
			URLQueryItem(name: "sort_by", value: "popularity.desc"),
			URLQueryItem(name: "api_key", value: NetworkContext.apiKey)
		]
		guard let url = urlComponents.url else {
			throw NetworkError.application
		}
	
		var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: NetworkContext.timeout)
		request.allHTTPHeaderFields = NetworkContext.headers
		
		return try await withCheckedThrowingContinuation{ continuation in

			let dataTask = URLSession.shared.dataTask(with: request) { data, netResponse, error in
				let error = NetworkError.make(statusCode: (netResponse as? HTTPURLResponse)?.statusCode)
				
				guard let data = data, error == nil else {
					return continuation.resume(throwing: error ?? .unknown)
				}
				
				guard let response = try? JSONDecoder().decode(NetSearchMoviesResponse.self, from: data) else {
					return continuation.resume(throwing: NetworkError.parse)
				}
				continuation.resume(returning: response)
			}
			dataTask.resume()
		}
	}
}
