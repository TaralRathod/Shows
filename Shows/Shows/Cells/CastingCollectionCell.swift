//
//  CastingCollectionCell.swift
//  Shows
//
//  Created by Taral Rathod on 01/05/21.
//

import UIKit
import EasyRenderer

class CastingCollectionCell: UICollectionViewCell {
    @IBOutlet weak var castImageView: EasyRendererImageView!
    @IBOutlet weak var castNameLabel: UILabel!

    private var castImageLayer: CAGradientLayer?
    private var nameLabelLayer: CAGradientLayer?

    func setupUI<T>(model: T) {
        if let cast = model as? Cast {
            castImageView.addCornerRadius(radius: castImageView.frame.height / 2, borderWidth: 1, borderColor: .clear)
            castNameLabel.text = cast.name ?? StringKeys.blank
            let path = String(cast.profilePath?.dropFirst() ?? "")
            let imageURL = String(format: KeyConstants.imageBaseUrl, path)
            castImageView.getImageFor(url: imageURL, placeholder: #imageLiteral(resourceName: "ticket")) { [weak self] (image, _) in
                DispatchQueue.main.async {
                    if image != nil {
                        self?.castImageView.image = image
                    } else {
                        self?.castImageView.image = #imageLiteral(resourceName: "ticket")
                    }
                }
            }
        } else if let result = model as? SuggestionResult {
            castNameLabel.text = result.title ?? StringKeys.blank
            let path = String(result.posterPath?.dropFirst() ?? "")
            let imageURL = String(format: KeyConstants.imageBaseUrl, path)
            castImageView.getImageFor(url: imageURL, placeholder: #imageLiteral(resourceName: "ticket")) { [weak self] (image, _) in
                DispatchQueue.main.async {
                    if image != nil {
                        self?.castImageView.image = image
                    } else {
                        self?.castImageView.image = #imageLiteral(resourceName: "ticket")
                    }
                }
            }
        }
    }

    func startAnimation() {
        castImageLayer = castImageView.startAnimating()
        nameLabelLayer = castNameLabel.startAnimating()
    }

    func stopAnimation() {
        stopAnimation(layer: castImageLayer ?? CAGradientLayer())
        stopAnimation(layer: nameLabelLayer ?? CAGradientLayer())
    }
}
