//
//  DBError.swift
//  MovieDB
//
//  Created by Yury Shubin on 23.01.22.
//

import Foundation

enum DBError: Error {
	case setup(message: String)
}
