//
//  CurrencyConverterVC.swift
//  CurrencyApp
//
//  Created by Asmaa Oraby on 04/06/2023.
//

import UIKit

class CurrencyConverterVC: UIViewController {
    
    @IBOutlet weak var conversionButton: UIButton!
    @IBOutlet weak var fromCurrencyButton: UIButton!
    @IBOutlet weak var toCurrencyButton: UIButton!
    
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var detailsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func conversionBtnAction(_ sender: Any) {
        print("conversionButton")
    }
    
    @IBAction func detailsBtnAction(_ sender: Any) {
        print("deatilsButton")
    }
}
