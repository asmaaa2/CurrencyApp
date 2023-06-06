//
//  CurrencyExchangeRemoteDataSource.swift
//  CurrencyApp
//
//  Created by Mahmoud Abdul-wahab on 12/11/2022.
//

import Foundation
protocol CurrencyExchangeRemoteDataSourceProtocol{
    func doExchange(from: String, to: String, amount: Double) async throws -> ExchangeCurrencyResponse
}

class CurrencyExchangeRemoteDataSource: CurrencyExchangeRemoteDataSourceProtocol {
    func doExchange(from: String, to: String, amount: Double) async throws -> ExchangeCurrencyResponse {
        try await NetworkManager.shared.sendRequest(urlRequest: CurrencyLayerRouter.exchange(from: from, to: to, amount: amount))
    }
}

