//
//  DBContext.swift
//  MovieDB
//
//  Created by Yury Shubin on 22.01.22.
//

import Foundation
import MagicalRecord

class DBContext
{
	private(set) var ctx: NSManagedObjectContext

	init()
	{
		self.ctx = NSManagedObjectContext.mr_default()
	}
	
	func save()
	{
		self.ctx.mr_saveToPersistentStoreAndWait()
	}
}
