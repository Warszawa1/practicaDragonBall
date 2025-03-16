//
//  UIImage+Remote.swift
//  KCDragonBall
//
//  Created by Ire  Av on 16/3/25.
//

import UIKit


// Método para descargar imagenes a través de url. Kingfisher es una libreria con uso similar
extension UIImageView {
    func setImage(url: URL) {
        downloadWithURLSession(url: url) { [weak self] result in
            switch result {
                case let .success(image):
                DispatchQueue.main.async {
                    self?.image = image
                }
                case .failure:
                    break
            }
        }
    }
    
    private func downloadWithURLSession(
        url: URL,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) {
        URLSession.shared.dataTask(with: url) {data, response, error in
            guard let data,
                  let image = UIImage(data: data) else {
                completion(.failure(NSError(domain: "Image Download Error", code: 0)))
                return
            }
            completion(.success(image))
        }
        .resume()
    }
}
