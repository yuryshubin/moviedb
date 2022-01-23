//
//  UINavigationControllerEx.swift
//  MovieDB
//
//  Created by Yury Shubin on 22.01.22.
//

import Foundation
import UIKit

class UINavigationControllerEx: UINavigationController
{
	@IBOutlet var noConnectionView: UIView!
	private var lastConnectionStatus = ConnectionStatus.notSpecified

	override func awakeFromNib() {
		super.awakeFromNib()
		self.view.addSubview(self.noConnectionView)
		self.noConnectionView.alpha = 0
		self.noConnectionView.translatesAutoresizingMaskIntoConstraints = false
		self.noConnectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
		self.noConnectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
		self.view.trailingAnchor.constraint(equalTo: self.noConnectionView.trailingAnchor).isActive = true
		self.navigationBar.bottomAnchor.constraint(equalTo: self.noConnectionView.bottomAnchor).isActive = true
		
		self.lastConnectionStatus = Model.default.statusNotifier.connectionStatus
		
		Model.default.statusNotifier.onConnectionStateChanged = {connected in
			
			UIView.animate(withDuration: ConstantsUI.animationDuration) {
				self.noConnectionView.alpha = connected ? 0 : 1
			}
		}
	}
}
