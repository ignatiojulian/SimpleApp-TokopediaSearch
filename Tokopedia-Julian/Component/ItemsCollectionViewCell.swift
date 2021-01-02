//
//  ItemsCollectionViewCell.swift
//  Tokopedia-Julian
//
//  Created by Ignatio Julian on 1/2/21.
//

import UIKit
import Kingfisher

class ItemsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblPrice: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
}
