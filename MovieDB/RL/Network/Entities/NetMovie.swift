//
//  NetMovie.swift
//  MovieDB
//
//  Created by Yury Shubin on 21.01.22.
//

import Foundation

struct NetMovie: Decodable
{
	let id: Int32
	let title: String
	let overview: String
	let popularity: Float
	let poster_path: String?
	let backdrop_path: String?
}
