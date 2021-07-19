//
//  Extension.swift
//  kumparantest2021
//
//  Created by Ivan Martin on 19/07/2021.
//

import UIKit

extension UIImageView {
    func setImage(from url: String) {
        fetchImage(withUrlString: url) { (image) in
            DispatchQueue.main.async {
                if let img = image {
                    self.image = img
                }
            }
        }
    }
    
    private func fetchImage(withUrlString urlString: String, completion: @escaping(UIImage?) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Failed to fetch image with error: ", error.localizedDescription)
                completion(nil)
                return
            }
            guard let data = data else {
                completion(nil)
                return }
            guard let image = UIImage(data: data) else {
                completion(nil)
                return }
            completion(image)
            
        }.resume()

    }
    
    func enableZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
    }
    
    @objc
    private func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
    
}
