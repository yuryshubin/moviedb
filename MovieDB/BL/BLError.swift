//
//  BLError.swift
//  MovieDB
//
//  Created by Yury Shubin on 23.01.22.
//

import Foundation

enum BLError: Error {
	case configuration
	case dataCorrupted(_ underlyingError: Error? = nil)
	case unknown(_ underlyingError: Error? = nil)
	case dataNotAvailable(_ underlyingError: Error? = nil)
	case logic(_ underlyingError: Error? = nil)
	case fatal
}
