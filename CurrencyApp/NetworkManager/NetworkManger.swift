//
//  NetworkManager.swift
//  CurrencyApp
//
//  Created by Asmaa Oraby on 05/06/2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL(String)
    case invalidResponse(String)
    case decodingError(String)
    case genericError(String)
    case internetError(String)
    
}

class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    
    private var baseURL: URL {
        return URL(string: infoForKey("BaseUrl") ?? "") ?? URL(fileURLWithPath: "")
//        return URL(string: "https://data.fixer.io/api/")!
    }

    public func infoForKey(_ key: String) -> String? {
            return (Bundle.main.infoDictionary?[key] as? String)?
                .replacingOccurrences(of: "\\", with: "")
     }
    
    public func getDataResponse(urlString: String, queryItems: [String: String]? = nil, completionBlock: @escaping (Result<[String: Any], Error>) -> Void) {
        let URL = baseURL.appendingPathComponent(urlString)
        var urlComponents = URLComponents(url: URL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = self.getQueryItems(queryItemDictionary: queryItems)
        guard let fullURL = urlComponents?.url else {
            completionBlock(.failure(NetworkError.invalidURL("Invalid URL error")))
            return
        }
        
           let task = URLSession.shared.dataTask(with: fullURL) { data, response, error in
               guard error == nil else {
                   completionBlock(.failure(NetworkError.internetError("Network is unavailable. Please try after some time")))
                   return
               }
               
               guard let responseData = data else {
                   completionBlock(.failure(NetworkError.genericError("Issue occured")))
                   return
               }

               guard let json = (try? JSONSerialization.jsonObject(with: responseData, options: [])) as? [String: AnyObject] else {
                   completionBlock(.failure(NetworkError.decodingError("Invalid Response")))
                   return
               }
               
               guard let httpResponse = response as? HTTPURLResponse,
                   200 ..< 300 ~= httpResponse.statusCode else {
                       completionBlock(.failure(NetworkError.genericError("Issue occured")))
                       return
               }
               
               if let status = json["success"] as? Bool, !status, let errorJson = json["error"] as? [String: Any], let errorMessage = errorJson["info"], let errorString = errorMessage as? String {
                   
                   completionBlock(.failure(NetworkError.invalidResponse(errorString)))
               } else {
                   completionBlock(.success(json))
               }
               
           }
           task.resume()
       }
    
    
    private func getQueryItems(queryItemDictionary: [String: String]?) -> [URLQueryItem] {
        var items = [URLQueryItem]()
        items.append(URLQueryItem(name: StringConstants.accessKey, value: self.infoForKey("APIKey")!))
        guard let itemDictionary = queryItemDictionary else {
            return items
        }
        for key in itemDictionary.keys {
            items.append(URLQueryItem(name: key, value: itemDictionary[key]))
        }
        
        return items
    }
    
}
