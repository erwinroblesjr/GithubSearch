//
//  SearchViewController.swift
//
//  Created by Erwin Robles on 8/29/21.
//

import UIKit
import Lottie

class SearchViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var repositoryTable: UITableView!
    @IBOutlet weak var noItems: UILabel!
    @IBOutlet weak var searching: AnimationView!
    @IBOutlet weak var error: AnimationView!
    
    @IBOutlet weak var searchFieldTopConstraint: NSLayoutConstraint!
    
    private var keyword: String = ""
    private var isFetchingRepositoryFromServer = false
    private var searchViewModel: SearchViewModel!
    private var customDataSource : CustomDataSource<RepositoryCell, Repository>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViews()
        initializeViewModel()
        initializeDatasource()
        initializeSearchinAnimation()
        initializeErrorAnimation()
        searchField.attributedPlaceholder = NSAttributedString(string: LocalizedStringEnum.search.rawValue, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    @IBAction func onSearchButtonTapped(_ sender: Any) {
        if !(searchField.text?.isEmpty ?? false){
            self.keyword = self.searchField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            self.noItems.isHidden = true
            self.clearRepositories()
            self.startSearchingAnimation()
            self.stopErrorAnimation()
            self.fetchRepositoryFromServer()
        }
    }
    
    private func initializeViewModel(){
        self.searchViewModel =  SearchViewModel()
        self.searchViewModel?.bindRepositoryViewModelToController = {
            self.isFetchingRepositoryFromServer = false
            self.updateDataSource()
        }
        self.searchViewModel.failedRequest = {
            self.isFetchingRepositoryFromServer = false
            DispatchQueue.main.async {
                self.stopSearchingAnimation()
                if self.searchViewModel.repositories?.items?.count ?? 0 < 1{
                    self.startErrorAnimation()
                }else{
                    self.repositoryTable.reloadData()
                }
            }
        }
    }
    
    private func fetchRepositoryFromServer(reloadTable: Bool? = false){
        if !isFetchingRepositoryFromServer{
            isFetchingRepositoryFromServer = true
            if reloadTable ?? false{
                repositoryTable.reloadData()
            }
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                self.keyword = self.searchField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                self.searchViewModel?.getRepositories(keyword: self.keyword)
            }
        }
    }
    
    private func updateDataSource(){
        DispatchQueue.main.async {
            if self.searchViewModel.repositories?.totalCount ?? 0  < 1{
                self.noItems.isHidden = false
                self.noItems.text = LocalizedStringEnum.noItems(keyword: self.keyword).rawValue
            }else{
                self.customDataSource.items = self.searchViewModel.repositories?.items
                self.repositoryTable.reloadData()
            }
            self.stopSearchingAnimation()
        }
    }
    
    private func initializeDatasource(){
        self.customDataSource = CustomDataSource(cellIdentifier: NibNameEnum.RepositoryCell.rawValue, items: []) { (cell, repositoryModel, index) in
            cell.repositoryName.text = repositoryModel.fullName
            cell.descriptionLabel.text = repositoryModel.description
            cell.starGazerCount.text = "\(repositoryModel.stargazersCount ?? 0)"
            cell.language.text = repositoryModel.language
            cell.dateLabel.text = LocalizedStringEnum.updateOn(date: repositoryModel.pushedAt?.getDateString() ?? "").rawValue
            let isLastIndex = index + 1 == self.searchViewModel.repositories?.items?.count
            cell.showLoadingAnimation(show: isLastIndex && self.isFetchingRepositoryFromServer)
            cell.endOfList.isHidden = !(isLastIndex && self.searchViewModel.repositories?.isAllItemsLoaded ?? false)
        }
        customDataSource.didSelectItem = { (repositoryModel) in
            self.performSegue(withIdentifier: SegueIdentifierEnum.showWebview.rawValue, sender: repositoryModel.htmlUrl)
        }
        customDataSource.scrolledToEnd = { () in
            if !(self.searchViewModel.repositories?.isAllItemsLoaded ?? false){
                self.fetchRepositoryFromServer(reloadTable: true)
            }
        }
        self.repositoryTable.dataSource = self.customDataSource
        self.repositoryTable.delegate = self.customDataSource
        self.repositoryTable.register(UINib(nibName: NibNameEnum.RepositoryCell.rawValue, bundle: nil), forCellReuseIdentifier: NibNameEnum.RepositoryCell.rawValue)
    }
    
    private func initializeSearchinAnimation(){
        searching.contentMode = .scaleAspectFit
        searching.loopMode = .loop
        searching.animationSpeed = 1
    }
    
    private func initializeErrorAnimation(){
        error.contentMode = .scaleAspectFit
        error.loopMode = .loop
        error.animationSpeed = 1
    }
    
    private func startSearchingAnimation(){
        searching.isHidden = false
        searching.play()
    }
    
    private func stopSearchingAnimation(){
        searching.isHidden = true
        searching.stop()
    }
    
    private func startErrorAnimation(){
        error.isHidden = false
        error.play()
    }
    
    private func stopErrorAnimation(){
        error.isHidden = true
        error.stop()
    }
    
    private func clearRepositories(){
        searchViewModel.clearRepositories()
        self.customDataSource.items = []
        repositoryTable.reloadData()
    }
    
    private func initializeViews(){
        searchField.layer.borderColor = UIColor.gray.cgColor
        searchButton.layer.borderColor = UIColor.gray.cgColor
    }
    
}

extension SearchViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let webViewController = segue.destination as? WebViewController {
            let webUrl = sender as? String ?? ""
            webViewController.setWebUrl(webUrl: webUrl)
        }
    }
}
