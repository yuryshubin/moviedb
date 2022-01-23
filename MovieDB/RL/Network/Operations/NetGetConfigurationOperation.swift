//
//  NetGetConfigurationOperation.swift
//  MovieDB
//
//  Created by Yury Shubin on 22.01.22.
//

import Foundation

class NetGetConfigurationOperation
{
	func exec() async throws -> NetGetConfigurationResponse {
		
		guard var urlComponents = URLComponents(string: NetworkContext.baseURL) else {
			throw NetworkError.application
		}

		urlComponents.path += "/configuration"
		urlComponents.queryItems = [
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
					return continuation.resume(throwing: error ?? NetworkError.unknown)
				}
				
				guard let response = try? JSONDecoder().decode(NetGetConfigurationResponse.self, from: data) else {
					return continuation.resume(throwing: NetworkError.parse)
				}
				continuation.resume(returning: response)
			}
			dataTask.resume()
		}		
	}
}
