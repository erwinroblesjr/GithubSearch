//
//  URLComponents+Extension.swift
//
//  Created by Erwin Robles on 8/31/21.
//
import Foundation
extension URLComponents{
    
    func getQueryItems(queries: [String: Any]) -> [URLQueryItem] {
        var newQueryItems: [URLQueryItem] = []
        for (key, value) in queries{
            newQueryItems.append(URLQueryItem(name: key, value: "\(value)"))
        }
        return newQueryItems
    }
}
