//
//  ListingViewCell.swift
//  Shows (iOS)
//
//  Created by Taral Rathod on 28/04/21.
//

import UIKit
import EasyRenderer

class ListingViewCell: UITableViewCell {

    @IBOutlet weak var showImageView: EasyRendererImageView!
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var showReleaseDateLabel: UILabel!
    @IBOutlet weak var showDetailsLabel: UILabel!
    @IBOutlet weak var bookButton: UIButton!

    private var titleLabelLayer: CAGradientLayer?
    private var imageViewLayer: CAGradientLayer?
    private var releaseDateLabelLayer: CAGradientLayer?
    private var detailsLabelLayer: CAGradientLayer?

    public var callbackBookSelection: ((UIButton) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        self.addCornerRadius(radius: 15, borderWidth: 1, borderColor: .clear)
        bookButton.addCornerRadius(radius: 10, borderWidth: 1, borderColor: .clear)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setShowValues(show: Result) {
        showTitleLabel.text = show.title ?? StringKeys.blank
        showReleaseDateLabel.text = String(format: StringKeys.releasedOn, show.releaseDate ?? StringKeys.blank)
        showDetailsLabel.text = show.overview ?? StringKeys.blank
        let imageURLString = String(format: KeyConstants.imageBaseUrl, show.posterPath ?? StringKeys.blank)
        showImageView.getImageFor(url: imageURLString, placeholder: #imageLiteral(resourceName: "ticket")) { [weak self] (image, _) in
            if image != nil {
                DispatchQueue.main.async {
                    self?.showImageView.image = image
                }
            }
        }
    }

    func startLoading() {
        bookButton.isHidden = true
        titleLabelLayer = showTitleLabel.startAnimating()
        imageViewLayer = showImageView.startAnimating()
        releaseDateLabelLayer = showReleaseDateLabel.startAnimating()
        detailsLabelLayer = showDetailsLabel.startAnimating()
    }

    func stopLoading() {
        bookButton.isHidden = false
        stopAnimation(layer: titleLabelLayer ?? CAGradientLayer())
        stopAnimation(layer: imageViewLayer ?? CAGradientLayer())
        stopAnimation(layer: releaseDateLabelLayer ?? CAGradientLayer())
        stopAnimation(layer: detailsLabelLayer ?? CAGradientLayer())
    }

    @IBAction func bookButtonTapped(_ sender: UIButton) {
        callbackBookSelection?(sender)
    }
}
