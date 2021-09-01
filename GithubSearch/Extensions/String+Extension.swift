//
//  TableViewCell.swift
//
//  Created by Erwin Robles on 8/30/21.
//

import UIKit

extension String{
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        guard let date = formatter.date(from: self) else{
            return self
        }
        formatter.dateStyle = DateFormatter.Style.medium
        return formatter.string(from: date)
    }
}
