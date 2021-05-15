//
//  StockListCell.swift
//  FinanceStackApp
//
//  Created by RN on 09/05/21.
//

import UIKit

class StockListCell: UITableViewCell {

    @IBOutlet weak var marketLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func bind(_ viewModel: StockViewModel) {
        stockNameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        marketLabel.text = viewModel.market
    }

}
