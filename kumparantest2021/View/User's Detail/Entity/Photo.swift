//
//  Photo.swift
//  kumparantest2021
//
//  Created by Ivan Martin on 19/07/2021.
//

import UIKit

struct Photo: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

class PhotoDetails {
    var photo: Photo
    var thumbnailImage: UIImage?
    var image: UIImage?
    
    init(photo: Photo, thumbnailImage: UIImage?, image: UIImage?) {
        self.photo = photo
        self.thumbnailImage = thumbnailImage
        self.image = image
    }
}
/*
 {
     "albumId": 1,
     "id": 1,
     "title": "accusamus beatae ad facilis cum similique qui sunt",
     "url": "https://via.placeholder.com/600/92c952",
     "thumbnailUrl": "https://via.placeholder.com/150/92c952"
   }
 */
