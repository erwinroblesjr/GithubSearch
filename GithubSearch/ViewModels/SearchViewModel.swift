//
//  SearchViewModel.swift
//
//  Created by Erwin Robles on 8/29/21.
//

import UIKit

class SearchViewModel: NSObject {
    
    private var apiService :APIService!
    
    private(set) var repositories :Repositories?
    
    var bindRepositoryViewModelToController : (() -> ()) = {}
    var failedRequest : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService =  APIService()
    }
    
    func getRepositories(keyword: String){
        if self.repositories == nil{
            self.repositories = Repositories(page: 1, totalCount: nil, items: [])
        }
        
        let queries: [String: Any] = [QueryEnum.q.rawValue: keyword, QueryEnum.perPage.rawValue: QueryEnum.perPage.defaultNumberValue(value: nil), QueryEnum.page.rawValue: QueryEnum.page.defaultNumberValue(value: self.repositories?.page)]
        
        apiService.getRepositories(queries: queries) { (repositories, success, failed) in
            if success{
                let currentPage = (self.repositories?.page ?? 0) + 1
                self.repositories?.page = currentPage
                self.repositories?.totalCount = repositories?.totalCount
                self.repositories?.items?.append(contentsOf: repositories?.items ?? [])
                self.bindRepositoryViewModelToController()
            }
            if failed{
                self.failedRequest()
            }
            
        }
    }
    
    func clearRepositories() {
        repositories = nil
    }
}
