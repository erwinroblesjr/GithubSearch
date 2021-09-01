//
//  LocalizedStringEnum.swift
//
//  Created by Erwin Robles on 8/29/21.
//

import UIKit

enum LocalizedStringEnum {
    case search
    case noItems(keyword: String)
    case updateOn(date: String)
    
    var rawValue: String{
        switch self
    {
        case .search:
            return "Search"
        case .noItems(let keyword):
            return "We couldn’t find any repositories matching \'\(keyword)\'"
        case .updateOn(let date):
            return "Updated on \(date)"
        }
    }
}

