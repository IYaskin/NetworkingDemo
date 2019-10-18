//
//  ImageViewController.swift
//  Networking
//
//  Created by Alexey Efimov on 27.07.2018.
//  Copyright © 2018 Alexey Efimov. All rights reserved.
//

import UIKit
import Alamofire

class ImageViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    private let url = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    private let largeImageUrl = "https://i.imgur.com/3416rvI.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        progressView.isHidden = true
        completeLabel.isHidden = true
    }
    
    func fetchImage() {
        
        NetworkManager.downloadImage(url: url) { (image) in
            
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
        }
    }
    
    func fetchImageWithAlamofire() {
        
        AlamofireNetworkRequest.downloadImage(url: url) { (image) in

            self.activityIndicator.stopAnimating()
            self.imageView.image = image
        }
    }
    
    func downloadImageWithProgress() {
        
        AlamofireNetworkRequest.onProgress = { progress in
            self.progressView.isHidden = false
            self.progressView.progress = Float(progress)
        }
        
        AlamofireNetworkRequest.completed = { completed in
            self.completeLabel.isHidden = false
            self.completeLabel.text = completed
        }

        AlamofireNetworkRequest.downloadImageWithProgress(url: largeImageUrl) { (image) in
            self.activityIndicator.stopAnimating()
            self.progressView.isHidden = true
            self.completeLabel.isHidden = true
            self.imageView.image = image
        }
        
    }
    
    
}
