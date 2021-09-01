//
//  CustomDataSource.swift
//
//  Created by Erwin Robles on 8/29/21.
//
import Foundation
import UIKit

class CustomDataSource<CELL : UITableViewCell, T> : NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var cellIdentifier : String!
    private var headerCellIdentifier : String!
    var items : [T]!
    var configureCell : (CELL, T, Int) -> () = {_,_,_ in }
    var didSelectItem : (T) -> () = {_ in }
    var scrolledToEnd : () -> () = {}
    
    init(cellIdentifier : String, items : [T]?, configureCell : @escaping (CELL, T, Int) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items =  items
        self.configureCell = configureCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items == nil{
            return 0
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CELL
        
        let item = self.items[indexPath.row]
        self.configureCell(cell, item, indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        didSelectItem(item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if items.count < 1{
            return
        }
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            scrolledToEnd()
        }
    }
}
