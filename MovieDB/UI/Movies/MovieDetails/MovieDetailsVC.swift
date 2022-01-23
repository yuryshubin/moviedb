//
//  MovieDetailsVC.swift
//  MovieDB
//
//  Created by Yury Shubin on 23.01.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class MovieDetailsVC: UIViewController
{
    private(set) var interactor: MovieDetailsBusinessLogic!
    private(set) var router: (NSObjectProtocol & MovieDetailsRoutingLogic & MovieDetailsDataPassing)!
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    // MARK: Setup
    private func setup()
    {
        let vc = self
        let interactor = MovieDetailsInteractor()
        let presenter = MovieDetailsPresenter()
        let router = MovieDetailsRouter()
        vc.interactor = interactor
        vc.router = router
        interactor.presenter = presenter
        presenter.vc = vc
        router.vc = vc
        router.dataStore = interactor
    }
    
    // MARK: Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        self.router.perform(NSSelectorFromString("routeTo\(segue.identifier!)WithSegue:"), with: segue)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        return self.router.responds(to: NSSelectorFromString("routeTo\(identifier)WithSegue:"))
    }
	
	// MARK: Custom
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var labelTitle: UILabel!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
}

protocol MovieDetailsDisplayLogic: AnyObject {
	func showMovie(_ movie: MovieDetails.SharedViewModel.DisplayMovie)
}

extension MovieDetailsVC: MovieDetailsDisplayLogic
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
		self.interactor.exec(MovieDetails.Show.Request())
    }
	
	func showMovie(_ movie: MovieDetails.SharedViewModel.DisplayMovie) {
		self.labelTitle.text = movie.title
		self.textView.text = movie.overview

		if let url = movie.backdropImageURL
		{
			self.imageView.sd_setImage(with: url) { _, error, _, _ in
				self.activityIndicator.stopAnimating()
				
				if error != nil
				{
					self.imageView.image = UIImage(named: "no-poster")
				}
			}
		}
	}
}
