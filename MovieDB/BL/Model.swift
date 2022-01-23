//
//  Model.swift
//  MovieDB
//
//  Created by Yury Shubin on 22.01.22.
//

import Foundation
import SDWebImage

class Model{
	
	static var `default` = try! Model()
	let dataManager: DataManager
	let statusNotifier: StatusNotifier
	let blContext: BLContext
	
	init() throws
	{
		self.statusNotifier = StatusNotifier(url: NetworkContext.baseURL)
		SDImageCache.shared.config.maxDiskSize = 50 * 1024 * 1024
		
		guard let context = BLContext() else {
			print("fatal: can't initialize BLContext")
			throw BLError.fatal
		}
		
		self.blContext = context
		self.dataManager = DataManager(blContext: self.blContext)
		self.statusNotifier.startListening()
	}
		
	func goOffline() {
		self.statusNotifier.connectionStatus = .offline
		self.dataManager.goOffline()
	}
}
