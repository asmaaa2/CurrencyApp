//
//  OtherCurrencyDataTableViewCell.swift
//  CurrencyApp
//
//  Created by Asmaa Oraby on 07/06/2023.
//

import UIKit

class OtherCurrencyDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    public var cellModel : CurrencyModel! {
        didSet {
            self.titleLabel.text = cellModel.currencySymbol + " : " + cellModel.currencyValue
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        titleLabel.text = StringConstants.emptyString
    }

}
