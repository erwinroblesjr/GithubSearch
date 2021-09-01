//
//  APIService.swift
//
//  Created by Erwin Robles on 8/29/21.
//

import UIKit

class APIService: NSObject {
    
    private var urlComponents: URLComponents?
    
    override init() {
        urlComponents = URLComponents(string: ApiUrlEnum.baseUrl.rawValue)
    }
    
    private func getQueryItems(queries: [String: Any]) -> [URLQueryItem]{
        var newQueryItems: [URLQueryItem] = []
        for (key, value) in queries{
            newQueryItems.append(URLQueryItem(name: key, value: "\(value)"))
        }
        return newQueryItems
    }
    
    func getRepositories(queries: [String: Any], completion : @escaping (Repositories?, Bool, Bool) -> ()){
        urlComponents?.queryItems = getQueryItems(queries: queries)
        var sourceUrl = urlComponents?.url
        sourceUrl?.appendPathComponent(ApiUrlEnum.search.rawValue)
        sourceUrl?.appendPathComponent(ApiUrlEnum.repositories.rawValue)
        
        guard let sourceUrl = sourceUrl else {
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 60.0
        URLSession(configuration: sessionConfig).dataTask(with: sourceUrl) { (data, urlResponse, error) in
            if error != nil{
                completion(nil, false, true)
            }
            if let data = data {

                let jsonDecoder = JSONDecoder()

                do {
                    let resositoriesData = try jsonDecoder.decode(Repositories.self, from: data)
                    completion(resositoriesData, true, false)
                } catch (_) {

                }

            }

        }.resume()
    }
}
