//
//  CurrencyDataTableViewController.swift
//  CurrencyApp
//
//  Created by Asmaa Oraby on 07/06/2023.
//

import UIKit
import RxSwift
import RxCocoa

enum InformationType {
    case historicalData
    case otherCurrencyData
}

class CurrencyDataTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var currencyData = PublishSubject<[CurrencyModel]>()
    public var historicalData = PublishSubject<[HistoricalDataModel]>()
    public var informationType: InformationType = .historicalData
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    
    private func setupBinding(){
        switch informationType {
        case .historicalData:
            tableView.register(UINib(nibName: CellConstants.historicalDataCell, bundle: nil), forCellReuseIdentifier: String(describing: HistoricalDataTableViewCell.self))
            
            historicalData.bind(to: tableView.rx.items(cellIdentifier: CellConstants.historicalDataCell, cellType: HistoricalDataTableViewCell.self)) {  (row,track,cell) in
                cell.cellModel = track
                }.disposed(by: disposeBag)
            
        case .otherCurrencyData:
            tableView.register(UINib(nibName: CellConstants.otherCurrencyDataCell, bundle: nil), forCellReuseIdentifier: String(describing: OtherCurrencyDataTableViewCell.self))
            
            currencyData.bind(to: tableView.rx.items(cellIdentifier: CellConstants.otherCurrencyDataCell, cellType: OtherCurrencyDataTableViewCell.self)) {  (row,track,cell) in
                cell.cellModel = track
                }.disposed(by: disposeBag)
        }
        
        
    }
    
}
