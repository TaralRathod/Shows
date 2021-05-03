//
//  ReviewsCell.swift
//  Shows
//
//  Created by Taral Rathod on 01/05/21.
//

import UIKit
import EasyRenderer

class ReviewsCell: UITableViewCell {

    @IBOutlet weak var profileImageView: EasyRendererImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    private var profileImageLayer: CAGradientLayer?
    private var nameLabelLayer: CAGradientLayer?
    private var contentLabelLayer: CAGradientLayer?
    private var dateLabelLayer: CAGradientLayer?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupUI(result: Results) {
        userNameLabel.text = result.authorDetails?.username ?? "Anonymous"
        dateLabel.text = result.updatedAt ?? StringKeys.blank
        contentLabel.text = result.content ?? StringKeys.blank
        let path = String(result.authorDetails?.avatarPath?.dropFirst() ?? "")
        let imageURL = String(format: KeyConstants.imageBaseUrl, path)
        profileImageView.getImageFor(url: imageURL, placeholder: #imageLiteral(resourceName: "ticket")) { [weak self] (image, _) in
            if image != nil {
                DispatchQueue.main.async {
                    self?.profileImageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self?.profileImageView.image = #imageLiteral(resourceName: "ticket")
                }
            }
        }
    }

    func startAnimation() {
        profileImageLayer = profileImageView.startAnimating()
        nameLabelLayer = userNameLabel.startAnimating()
        contentLabelLayer = contentLabel.startAnimating()
        dateLabelLayer = dateLabel.startAnimating()
    }

    func stopAnimation() {
        stopAnimation(layer: profileImageLayer ?? CAGradientLayer())
        stopAnimation(layer: nameLabelLayer ?? CAGradientLayer())
        stopAnimation(layer: contentLabelLayer ?? CAGradientLayer())
        stopAnimation(layer: dateLabelLayer ?? CAGradientLayer())
    }
}
