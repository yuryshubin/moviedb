//
//  MoviesVC+UITableDataSource.swift
//  MovieDB
//
//  Created by Yury Shubin on 23.01.22.
//

import Foundation
import UIKit

extension MoviesVC: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModel?.items.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesVCTableViewCell", for: indexPath) as! MoviesVCTableViewCell
		cell.delegate = self
		
		cell.prepareForReuse()
		cell.update(self.viewModel!.items[indexPath.row])
		return cell
	}
}
