//
//  PhotoDetailVC.swift
//  kumparantest2021
//
//  Created by Ivan Martin on 19/07/2021.
//

import UIKit

class PhotoDetailVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = photo.title
        self.titleLabel.text = photo.title
        self.imageView.setImage(from: photo.url)
        self.imageView.enableZoom()
    }

}
