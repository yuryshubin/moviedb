//
//  DBManager.swift
//  MovieDB
//
//  Created by Yury Shubin on 22.01.22.
//

import Foundation
import MagicalRecord

class DBManager
{
	private class func createDBDirectory(dbFileURL: URL) throws
	{
		let directory = dbFileURL.deletingLastPathComponent()
		
		do {
			try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
		} catch let error {
			throw DBError.setup(message: error.localizedDescription)
		}
	}

	class func setup(dbFileURL: URL) throws
	{
		try self.createDBDirectory(dbFileURL: dbFileURL)
		let model = NSManagedObjectModel.mr_newModelNamed("db.momd", in: Bundle.main)
		NSManagedObjectModel.mr_setDefaultManagedObjectModel(model)
		MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStore(at: dbFileURL)
	}
}
