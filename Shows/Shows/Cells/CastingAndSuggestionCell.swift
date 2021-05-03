//
//  CastingAndSuggestionCell.swift
//  Shows
//
//  Created by Taral Rathod on 01/05/21.
//

import UIKit

class CastingAndSuggestionCell: UITableViewCell {

    @IBOutlet weak var castingCollectionView: UICollectionView!

    var contentArray: [AnyObject]?
    var isContentReceived = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        castingCollectionView.delegate = self
        castingCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupContent<T>(array: [T], isContentReceived: Bool) {
        contentArray = array as [AnyObject]
        self.isContentReceived = isContentReceived
        castingCollectionView.reloadData()
    }
}

extension CastingAndSuggestionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isContentReceived ? contentArray?.count ?? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableCellConstants.castingCollectionCell, for: indexPath) as? CastingCollectionCell else {return UICollectionViewCell()}
        if isContentReceived {
            cell.stopAnimation()
            guard let content = contentArray?[indexPath.row] else {return UICollectionViewCell()}
            cell.setupUI(model: content)
        } else {
            cell.startAnimation()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 200)
    }
}
