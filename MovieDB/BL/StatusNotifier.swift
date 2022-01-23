//
//  StatusNotifier.swift
//  MovieDB
//
//  Created by Yury Shubin on 22.01.22.
//

import Foundation
import Reachability

public enum ConnectionStatus: Int {
	case notSpecified = 0
	case online
	case offline
}

class StatusNotifier {
	private let url: URL
	private var reachability: Reachability?
	
	var onConnectionStateChanged: ((_ connected: Bool) -> Void)?
	
	var connectionStatus: ConnectionStatus = .notSpecified
	{
		didSet
		{
			if self.connectionStatus != oldValue
			{
				switch self.connectionStatus
				{
				case .online:
					self.onConnectionStateChanged?(true)
				case .offline:
					self.onConnectionStateChanged?(false)
				default:
					break
				}
			}
		}
	}
	
	init(url: String)
	{
		self.url = URL(string: url)!
	}
	
	func startListening()
	{
		let notify = {(connected: Bool) in
			self.connectionStatus = connected ? .online : .offline
		}
		
		self.reachability = try? Reachability(hostname: self.url.host!)
		self.reachability?.whenReachable = { reachability in notify(true) }
		self.reachability?.whenUnreachable = { reachability in notify(false) }
		try? self.reachability?.startNotifier()
	}
	
	func stopListening()
	{
		self.reachability?.whenReachable = nil
		self.reachability?.whenUnreachable = nil
		self.reachability?.stopNotifier()
		self.reachability = nil
		self.connectionStatus = .offline
	}
	
	func connectionIsReachable() -> Bool
	{
		guard let reachability = self.reachability, reachability.connection != .unavailable else
		{ return false }
		
		return true
	}
}
