//
//  MoviesVCTableViewCell.swift
//  MovieDB
//
//  Created by Yury Shubin on 21.01.22.
//

import Foundation
import UIKit
import SDWebImage

protocol RootVCTableViewCellDelegate: AnyObject
{
	func rootVCTableViewCellOnAnimateRequired(_ cell: MoviesVCTableViewCell)
}

class MoviesVCTableViewCell: UITableViewCell
{
	weak var delegate: RootVCTableViewCellDelegate?
	
	@IBOutlet weak var buttonCollapseToggle: UIButton!
	@IBOutlet weak var labelTitle: UILabel!
	@IBOutlet weak var labelDescription: UILabel!
	@IBOutlet weak var imageViewPoster: UIImageView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

	@IBOutlet weak var constraintImageViewBottomCollapsed: NSLayoutConstraint!
	@IBOutlet weak var constraintLabelDetailsBottomCollapsed: NSLayoutConstraint!

	@IBOutlet weak var constraintImageViewBottomExpanded: NSLayoutConstraint!
	@IBOutlet weak var constraintLabelDetailsBottomExpanded: NSLayoutConstraint!
	
	private var isCollapsed = true
		
	override func prepareForReuse() {
		super.prepareForReuse()
		self.imageViewPoster.image = UIImage(named: "no-poster")
		self.buttonCollapseToggle.transform = .identity
		
		let collapsed: [NSLayoutConstraint] = [self.constraintImageViewBottomCollapsed, self.constraintLabelDetailsBottomCollapsed]
		let expanded: [NSLayoutConstraint] = [self.constraintImageViewBottomExpanded, self.constraintLabelDetailsBottomExpanded]
		
		NSLayoutConstraint.activate(collapsed)
		NSLayoutConstraint.deactivate(expanded)
	}
	
	func update(_ movie: Movies.SharedViewModel.DisplayMovie) {
		
		self.labelTitle.text = movie.title
		self.labelDescription.text = movie.overview
		
		if let url = movie.imageURL
		{
			self.activityIndicator.startAnimating()
			self.imageViewPoster.sd_setImage(with: url) { image, error, _, _ in
				self.activityIndicator.stopAnimating()
			}
		} else {
			self.activityIndicator.stopAnimating()
		}
		
		self.buttonCollapseToggle.isHidden = !self.isTruncated
	}
	
	var isTruncated: Bool {
		guard let text = self.labelDescription.text, !text.isEmpty else
		{ return false }
		
		let s = CGSize(width: self.labelDescription.frame.width, height: CGFloat.greatestFiniteMagnitude)
		let labelTextSize = self.labelDescription.sizeThatFits(s)
		return labelTextSize.height > self.labelDescription.bounds.height
	}
		
	func toggle() {
		
		let collapsed: [NSLayoutConstraint] = [self.constraintImageViewBottomCollapsed, self.constraintLabelDetailsBottomCollapsed]
		let expanded: [NSLayoutConstraint] = [self.constraintImageViewBottomExpanded, self.constraintLabelDetailsBottomExpanded]
		
		NSLayoutConstraint.activate(self.isCollapsed ? collapsed : expanded)
		NSLayoutConstraint.deactivate(self.isCollapsed ? expanded : collapsed)
		
		let radians = Measurement(value: Double(180) * 1, unit: UnitAngle.degrees).converted(to: .radians).value
		UIView.animate(withDuration: ConstantsUI.animationDuration) {
			self.buttonCollapseToggle.transform = self.isCollapsed ? .identity : CGAffineTransform(rotationAngle: radians)
		}
	}
		
	@IBAction func onToggleExpand() {
		
		self.isCollapsed = !self.isCollapsed
		self.delegate?.rootVCTableViewCellOnAnimateRequired(self)
	}
}
