//
//  DetailsViewCell.swift
//  Shows
//
//  Created by Taral Rathod on 01/05/21.
//

import UIKit
import EasyRenderer

class DetailsViewCell: UITableViewCell {

    @IBOutlet weak var showImageView: EasyRendererImageView!
    @IBOutlet weak var showName: UILabel!
    @IBOutlet weak var certificateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    private var showImageLayer: CAGradientLayer?
    private var nameLabelLayer: CAGradientLayer?
    private var certificateLabelLayer: CAGradientLayer?
    private var descriptionLabelLayer: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupUI(model: SynopsisModel) {
        showName.text = model.title ?? StringKeys.blank
        certificateLabel.text = model.adult ?? false ? "Certificate: U/A" : "Certificate: A"
        descriptionLabel.text = model.overview ?? StringKeys.blank
        let path = String(model.backdropPath?.dropFirst() ?? "")
        let imageURL = String(format: KeyConstants.imageBaseUrl, path)
        showImageView.getImageFor(url: imageURL, placeholder: #imageLiteral(resourceName: "ticket")) { [weak self] (image, _) in
            if image != nil {
                DispatchQueue.main.async {
                    self?.showImageView.image = image
                }
            }
        }
    }

    func startAnimation() {
        showImageLayer = showImageView.startAnimating()
        nameLabelLayer = showName.startAnimating()
        certificateLabelLayer = certificateLabel.startAnimating()
        descriptionLabelLayer = descriptionLabel.startAnimating()
    }

    func stopAnimation() {
        stopAnimation(layer: showImageLayer ?? CAGradientLayer())
        stopAnimation(layer: nameLabelLayer ?? CAGradientLayer())
        stopAnimation(layer: certificateLabelLayer ?? CAGradientLayer())
        stopAnimation(layer: descriptionLabelLayer ?? CAGradientLayer())
    }
}
