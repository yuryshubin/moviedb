//
//  NetworkError.swift
//  MovieDB
//
//  Created by Yury Shubin on 21.01.22.
//

import Foundation

enum NetworkError: Error
{
	case application
	case parse
	case server
	case client
	case unknown
	
	static func make(statusCode: Int?) -> NetworkError?
	{
		guard let code = statusCode else {
			return .unknown
		}
		
		switch code
		{
		case 200...299:
			return nil
		case 400...499:
			return .client
		case 500...599:
			return .server
		default:
			return .unknown
		}
	}
}
