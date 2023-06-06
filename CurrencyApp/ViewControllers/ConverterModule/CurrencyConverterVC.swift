//
//  CurrencyConverterVC.swift
//  CurrencyApp
//
//  Created by Asmaa Oraby on 04/06/2023.
//

import UIKit
import RxSwift
import RxCocoa
import DropDown

class CurrencyConverterVC: UIViewController {
    
    @IBOutlet weak var conversionButton: UIButton!
    @IBOutlet weak var fromCurrencyButton: UIButton!
    @IBOutlet weak var toCurrencyButton: UIButton!
    
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var detailsButton: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel: CurrencyExchangeViewModelProtocol
    var myMenu: DropDownMenuProtocol?
    
    //MARK: - Initialization
    init(viewModel: CurrencyExchangeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropDownMenu()
        bindUI()
        doExchange()
        ButtonsStyling()
        setupUI()
    }
    
    private func ButtonsStyling(){
        let buttonIcone = UIImage(systemName: "arrowtriangle.down")!
        toButton.addRightIcon(image: buttonIcone )
        fromButton.addRightIcon(image: buttonIcone)
    }
    
    private func setupDropDownMenu() {
        self.myMenu =  DropDownMenu( dataSource: viewModel.getCurrencySymboleList())
        self.myMenu?.selectedSymbolSubject.subscribe(onNext: {[weak self] in
            guard let self else{return}
            switch self.viewModel.currentState{
            case .from:
                self.fromButton.setTitle($0, for: .normal)
            case .to:
                self.toButton.setTitle($0, for: .normal)
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        fromTextField.text = viewModel.amountSubject.value.description
    }
    
    //MARK: - DataBinding
    private func bindUI() {
        
        viewModel
            .fromSubject
            .withUnretained(self)
            .subscribe(onNext: {
                $0.0.fromButton.setTitle($0.1, for: .normal)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .toSubject
            .withUnretained(self)
            .subscribe(onNext: {
                $0.0.toButton.setTitle($0.1, for: .normal)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .screenSubject
            .observe(on: MainScheduler.instance)
            .subscribe {[weak self] state in
                guard let self else {return}
                self.handleScreenState(state: state)
            }.disposed(by: disposeBag)
        
        fromTextField.rx.text
            .skip(2)
            .observe(on: MainScheduler.instance)
            .debounce(.milliseconds(900), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .compactMap({$0?.toDouble()})
            .do(onNext: {_ in self.viewModel.currentState = .from})
                .bind(to: self.viewModel.amountSubject)
                .disposed(by: disposeBag)
                
                toTextField.rx.text
                .skip(2)
                .observe(on: MainScheduler.instance)
                .debounce(.milliseconds(900), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
                .compactMap({$0?.toDouble()})
                .do(onNext: {_ in self.viewModel.currentState = .to})
                    .bind(to: self.viewModel.amountSubject)
                    .disposed(by: disposeBag)
                    
                    viewModel.amountSubject.subscribe(onNext: {[weak self] in
                        guard let self = self else {return}
                        self.onAmountChanged(amount: $0)
                    }).disposed(by: disposeBag)
                    
                    myMenu?.selectedSymbolSubject
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: {[weak self] symbole in
                        guard let self else{return}
                        self.onSelectedSymboleMenuChanged(symbole: symbole)
                    }).disposed(by: disposeBag)
                    
                    }
    
    private func onSelectedSymboleMenuChanged(symbole: String) {
        switch self.viewModel.currentState {
        case .from:
            self.viewModel.fromSubject.accept(symbole)
        case .to:
            self.viewModel.toSubject.accept(symbole)
        }
        self.doExchange()
    }
    
    private func onAmountChanged(amount: Double) {
        if case .to =  self.viewModel.currentState {
            Task{
                viewModel.doExchange(from: viewModel.toSubject.value,
                                     to: viewModel.fromSubject.value,
                                     amount: amount)
            }
        }else{
            self.doExchange()
        }
    }
    
    func handleScreenState(state: CurrencyExchangeState) {
        switch state {
        case .hideLodar:
            stopLoading()
        case .showLoader:
            startLoding()
        case .result(let text):
            self.bindResultText(text: text)
        case .showMessage(let message):
            self.showAlert(message: message)
        }
    }
    
    private func doExchange(){
        Task{
            viewModel.doExchange(from: viewModel.fromSubject.value,
                                 to: viewModel.toSubject.value,
                                 amount: viewModel.amountSubject.value)
        }
    }
    
    private func bindResultText(text: String){
        switch viewModel.currentState {
        case .from:
            toTextField.text = text
        case .to:
            fromTextField.text = text
        }
    }

    @IBAction func conversionBtnAction(_ sender: Any) {
        print("conversionButton")
    }
    
    @IBAction func detailsBtnAction(_ sender: Any) {
        print("deatilsButton")
    }
    private func startLoding(){
        activityIndicator.startAnimating()
    }
    
    private func stopLoading(){
        activityIndicator.stopAnimating()
    }
}

extension CurrencyConverterVC: Alertable {}

