//
//  StockDetailTableViewCell.swift
//  FinanceStackApp
//
//  Created by RN on 16/05/21.
//

import UIKit

class StockDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func bind(_ stockDetail: StockDetailListVM) {
        titleLabel.text = stockDetail.title
        detailLabel.text = stockDetail.value
    }

}
