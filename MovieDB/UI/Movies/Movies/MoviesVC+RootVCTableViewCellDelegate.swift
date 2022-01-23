//
//  MoviesVC+RootVCTableViewCellDelegate.swift
//  MovieDB
//
//  Created by Yury Shubin on 23.01.22.
//

import Foundation

extension MoviesVC: RootVCTableViewCellDelegate {
	
	func rootVCTableViewCellOnAnimateRequired(_ cell: MoviesVCTableViewCell) {
		
		self.tableView.performBatchUpdates {
			cell.toggle()
			self.view.layoutIfNeeded()
		} completion: { _ in }
	}
}
