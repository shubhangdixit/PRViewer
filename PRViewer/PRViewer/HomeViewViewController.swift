//
//  HomeViewViewController.swift
//  PRViewer
//
//  Created by Shubhang Dixit on 07/11/20.
//  Copyright © 2020 Shubhang. All rights reserved.
//

import UIKit

enum FilterOptions : String {
    
    case open = "Open"
    case closed = "Closed"
    case all = "All"
    
    static let allcases : [FilterOptions] = [.all, .open, .closed]
}

enum SearchState {
    case searched(String)
    case searching
    
    func buttonImage() -> UIImage {
        switch self {
        case .searched( _):
            return #imageLiteral(resourceName: "searchIcon")
        default:
            return #imageLiteral(resourceName: "closeIcon")
        }
    }
}

class HomeViewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var observer: NSKeyValueObservation?
    
    var selectedFilterOption : FilterOptions = .all
    
    let homeScreenValues = HomeScreenValues()
    
    var searchState : SearchState = .searched("") {
        didSet {
            switch searchState {
                
            case .searched(let key):
                searchBar.isHidden = true
                titleView.isHidden = false
                searchButton.setImage(searchState.buttonImage(), for: .normal)
                RepoManager.shared.filteredList(forSearchKey: key, andFilter: nil)
            case .searching:
                searchBar.isHidden = false
                titleView.isHidden = true
                searchButton.setImage(searchState.buttonImage(), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIforSubViews()
        
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        RepoManager.shared.initiateContent()
        
        observer = RepoManager.shared.observe(\.visiblePullRequests, options: [], changeHandler: { [weak self](object, change) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        })
    }
    
    func configureUIforSubViews() {
        
        view.backgroundColor = homeScreenValues.backgroundColor
        
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        topView.layer.shadowRadius = 1
        
        topView.layer.shadowPath = UIBezierPath(rect: topView.bounds).cgPath
        topView.layer.shouldRasterize = true
        view.bringSubviewToFront(topView)
        
        searchBar.isHidden = true
        titleView.isHidden = false
        searchButton.setImage(searchState.buttonImage(), for: .normal)
        titleView.text = RepoManager.shared.getRepoPath()
    }
    
    func selectFilter(forOption option : FilterOptions) {
        self.selectedFilterOption = option
        RepoManager.shared.filteredList(forSearchKey: nil, andFilter: option)
    }
    
    @IBAction func sortButtondidTapped(_ sender: Any) {
        let availableActions = FilterOptions.allcases.map { $0.rawValue }
        self.presentActionSheet(forActions: availableActions, senderView: sender as! UIView)
    }
    
    @IBAction func searchButtonDidTapped(_ sender: Any) {
        switch searchState {
        case .searched( _):
            searchState = .searching
        default:
            searchBarSearchButtonClicked(searchBar)
        }
    }
    
    //MARK:- UISearchBarDelegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.view.endEditing(true)
        searchState = .searched("")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        RepoManager.shared.filteredList(forSearchKey: searchBar.text ?? "", andFilter: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.view.endEditing(true)
        searchState = .searched(searchBar.text ?? "")
    }
    
    //MARK:- UITableViewDelegates and DataSources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RepoManager.shared.getNumberOfRors()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: PRTableViewCell.className) as? PRTableViewCell {
            cell.configureCell(forPR: RepoManager.shared.visiblePullRequests[indexPath.row])
            return cell
        } else {
            return UITableViewCell.init()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController : DetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: DetailsViewController.className) as? DetailsViewController {
            viewController.pullRequest = RepoManager.shared.visiblePullRequests[indexPath.row]
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
    }
}


extension HomeViewViewController {
    
    func presentActionSheet(forActions actionList : [String], senderView : UIView) {
        let titles = "Filter PRs based on State"
        var images : [String : String] = [:]
        images[selectedFilterOption.rawValue] = "Selection_Tick"
        
        self.showActionSheet("", title: titles, actionTittle: actionList, images: images, withHandler: sortSelectionHandler(action:), andSourceView: senderView)
    }
    
    func sortSelectionHandler(action: UIAlertAction) {
        if let filter = action.title, let filteringOption = FilterOptions(rawValue: filter) {
            self.selectFilter(forOption: filteringOption)
        }
    }
}
