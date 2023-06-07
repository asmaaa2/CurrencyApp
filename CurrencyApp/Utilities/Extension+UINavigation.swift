//
//  Extension+UINavigation.swift
//  CurrencyApp
//
//  Created by Asmaa Oraby on 07/06/2023.
//

import Foundation
import UIKit

extension UINavigationController {
    // delete Back word from navigation
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
