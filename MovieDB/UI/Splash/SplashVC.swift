//
//  SplashVC.swift
//  MovieDB
//
//  Created by Yury Shubin on 22.01.22.
//

import Foundation
import UIKit

class SplashVC: UIViewController {
		
	private func handle(succeeded: Bool) {
		
		guard let vc = UIStoryboard(name: "Movies", bundle: nil).instantiateViewController(withIdentifier: "MoviesVC") as? MoviesVC else
		{ return }

		if succeeded {
			self.navigationController!.viewControllers = [vc]
		}
		else {
			let alert = UIAlertController(title: "Error", message: "Can't fetch configuration", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: {_ in
				alert.dismiss(animated: true, completion: nil)
				self.configure()
			}))
			alert.addAction(UIAlertAction(title: "Go Offline", style: .default, handler: {_ in
				alert.dismiss(animated: true, completion: nil)
				Model.default.goOffline()
				self.navigationController!.viewControllers = [vc]
			}))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	private func configure() {

		Task {
			do {
				try await Model.default.dataManager.configure()
				self.handle(succeeded: true)
			} catch let error {
				print("\(error)")
				self.handle(succeeded: false)
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.configure()
	}
}
