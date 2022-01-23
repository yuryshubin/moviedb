//
//  NetworkContext.swift
//  MovieDB
//
//  Created by Yury Shubin on 21.01.22.
//

import Foundation

class NetworkContext
{
	static let baseURL = "https://api.themoviedb.org/3"
	static let timeout: TimeInterval = 10
	static let apiKey: String = "360a666fe67e753f71198a858cd0c5ec"
	static private let accessToken: String = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzNjBhNjY2ZmU2N2U3NTNmNzExOThhODU4Y2QwYzVlYyIsInN1YiI6IjYxZWFjYjJmYTBiNmI1MDA0NGRjZTk2YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.8lP0ET7okIBmxkb8-0rEC9MH3wCsYnBExEoelkv3FpM"

	static var headers: [String: String]
	{
		return [
			"content-type": "application/json;charset=utf-8"
//			"authorization": "Bearer \(self.accessToken)"
		]
	}
}
