//
//  StockDetailViewController.swift
//  FinanceStackApp
//
//  Created by RN on 14/05/21.
//

import UIKit

class StockDetailViewController: UIViewController, Storyboardable, Deinitcallable {
    var onDeinit: (() -> Void)?
    @IBOutlet weak var marketNameLabel: UILabel!
    @IBOutlet weak var exchangeNameLabel: UILabel!
    @IBOutlet weak var allTimeHighPriceDateLabel: UILabel!
    @IBOutlet weak var allTimePriceLowLabel: UILabel!
    @IBOutlet weak var allTimePriceLowDate: UILabel!
    @IBOutlet weak var marketTimeLabel: UILabel!
    @IBOutlet weak var allTimeHighPriceLabel: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
    var viewModel: StockDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        doBinding()
        // Do any additional setup after loading the view.
    }

    func doBinding() {
        let stockVM = viewModel.stockDetailVM
        self.title = stockVM.stockName
        
        exchangeNameLabel.text = stockVM.exchangeName
        marketNameLabel.text = stockVM.marketName
        marketTimeLabel.text = stockVM.marketTime
        priceValueLabel.text = stockVM.priceValue

        allTimeHighPriceLabel.text = stockVM.allTimeHighPrice
        allTimeHighPriceDateLabel.text = stockVM.allTimeHighPriceDate

        allTimePriceLowLabel.text = stockVM.allTimeLowPrice
        allTimePriceLowDate.text = stockVM.allTimeLowPriceDate
    }

    deinit {
        onDeinit?()
    }
}
