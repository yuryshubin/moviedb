//
//  NetGetConfigurationResponse.swift
//  MovieDB
//
//  Created by Yury Shubin on 21.01.22.
//

import Foundation

struct NetGetConfigurationResponse: Decodable
{
	private enum ImagesKeys: String, CodingKey {
		case base_url
		case secure_base_url
		case poster_sizes
		case backdrop_sizes
	}
	
	private enum RootKeys: String, CodingKey {
		case images
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: RootKeys.self)
		let imagesContainer = try container.nestedContainer(keyedBy: ImagesKeys.self, forKey: .images)
		self.base_url = try imagesContainer.decode(String.self, forKey: .base_url)
		self.secure_base_url = try imagesContainer.decode(String.self, forKey: .secure_base_url)
		self.poster_sizes = try imagesContainer.decode([String].self, forKey: .poster_sizes)
		self.backdrop_sizes = try imagesContainer.decode([String].self, forKey: .backdrop_sizes)
	}
	
	let base_url: String
	let secure_base_url: String
	let poster_sizes: [String]
	let backdrop_sizes: [String]
}
