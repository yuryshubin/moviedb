//
//  NetMovie.swift
//  MovieDB
//
//  Created by Yury Shubin on 21.01.22.
//

import Foundation

struct NetSearchMoviesResponse: Decodable
{
	let results: [NetMovie]
	let total_pages: Int
	let total_results: Int
}
