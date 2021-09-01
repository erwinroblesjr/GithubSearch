//
//  QueryEnum.swift
//
//  Created by Erwin Robles on 8/31/21.
//

enum QueryEnum: String {
    case q
    case perPage = "per_page"
    case page
    
    func defaultNumberValue(value: Int?) -> Int {
        switch self {
        case .perPage:
            return value ?? 10
        case .page:
            return value ?? 1
        default:
            return 0
        }
    }
}
