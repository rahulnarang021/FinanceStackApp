# FinanceStackApp
Support: iOS 12 and above
XCodeVersion Used: Xcode 12.3

Please do `pod install` before running the app. I have ignored Pods folder in gitignore to reduce size of the project.
Configuration: Please change this key if required (rapidAPIKeyValue in StockListAPIConstants) in case the limit exhausts

Application Architecture: MVVM + Coordinator + RxSwift

Modules:
    StockList:
        SearchQueryService: It contains logic to filter data on the basis of stockName/symbolName/exchange.
        API
            StockListAPIClient: It conforms to StockListClient protocol which interacts with APIManager in Networking and return response in Single format
            StockListResponse: It contains data received from the api which can be changed on the basis of API requirement. It’s created with an assumption on certain parameters (for optional and non-optional values) which can be changed if data is not parsed properly (Couldn’t find documentation of response).
        Coordinator
            StockListCoordinator: Created this as root coordinator which drives the application and compose the module
        ViewModel
            StockListViewModel: It contains ViewModel to which StockListViewController is binded to represent and search data on screen
        UI
            StockListViewController: It binds data between UI (i.e. cell, tableView and searchBar) with StockListViewModel
        VM
            StockViewModel: It represents data that is visible on each cell
    StockList:
        API
            StockDetailAPIClient: It conforms to StockDetailClient protocol which interacts with APIManager in Networking and return response in Single format
            StockDetailModel: It contains data received from the api which can be changed on the basis of API requirement. It’s created with an assumption on certain parameters (for optional and non-optional values) which can be changed if data is not parsed properly (Couldn’t find documentation of response).
        Coordinator
            StockListCoordinator: Created this as root coordinator which drives the application and compose the module
        ViewModel
            StockDetailViewModel: It contains ViewModel to which StockDetailViewController is binded to represent  data on screen using StockDetailVM
        UI
            StockDetailViewController: It binds data between UI (i.e. cell, tableView and searchBar) with StockListViewModel
        VM
            StockDetailVM: It represents data that is visible on each cell of the screen (gets created using StockDetailModel)


Helpers:
        CurrencyFormattingHelper: Created this singleton class to format price values in the project (especially stock detail screen)
        DateFormattingHelper: Created this singleton class to format dates in the project (especially stock detail screen)
Networking:
        APIManagerInput: Its a api protocol that has a single generic method to make api and return response which is Decodable
        APIManager: It’s a class that can be singleton to handle multiple api calls through out the project
