//
//  ListingsViewController.swift
//  Shows (iOS)
//
//  Created by Taral Rathod on 28/04/21.
//

import UIKit

class ListingsViewController: UIViewController {

    @IBOutlet weak var showsTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var searchController = UISearchController()
    private var listingsViewModel: ListingsViewModel?
    private var listingsArray = [Result]()
    private var filteredArray = [Result]()
    private var isResponseAvailable = false
    private var isInEditingMode = false
    private var page = 1

    private let cellSpacingHeight: CGFloat = 5

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableview()
        addSearchbar()
        getListings()
    }

    private func setupTableview() {
        showsTableView.delegate = self
        showsTableView.dataSource = self
        showsTableView.rowHeight = UITableView.automaticDimension
        showsTableView.estimatedRowHeight = 72
        showsTableView.tableFooterView = UIView()
    }

    private func addSearchbar() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }

    private func getListings() {
        listingsViewModel = ListingsViewModel(delegate: self)
        listingsViewModel?.getShowsList(page: page)
    }

    private func showError(type: ErrorType) {
        errorLabel.isHidden = false
        var message = StringKeys.blank
        if type == .dataNotAvailable {
            message = StringKeys.dataMessage
        } else if type == .errorOccoured {
            message = StringKeys.errorMessage
        } else {
            message = StringKeys.noSearchResult
        }

        self.errorLabel.text = message
    }

    private func navigateToDetailsScreen(movieId: String) {
        guard let detailsVC = ShowDetailsViewController.initializeFromStoryboard() else {return}
        detailsVC.movieId = movieId
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension ListingsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if isResponseAvailable {
            if filteredArray.count > 0 {
                errorLabel.isHidden = true
                return filteredArray.count
            } else {
                showError(type: .noResultFound)
                return 0
            }
        } else {
            return 3
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCellConstants.listingCell) as? ListingViewCell else {return UITableViewCell()}
        if isResponseAvailable {
            cell.stopLoading()
            let result = filteredArray[indexPath.section]
            cell.setShowValues(show: result)
        } else {
            cell.startLoading()
        }
        cell.callbackBookSelection = { [weak self] (_) in
            guard let result = self?.filteredArray[indexPath.section] else {return}
            let id = result.id ?? 0
            self?.navigateToDetailsScreen(movieId: String(id))
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        navigateToDetailsScreen()
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }

    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section + 1 == filteredArray.count && !isInEditingMode {
            page += 1
            listingsViewModel?.getShowsList(page: page)
        }
    }
}

extension ListingsViewController: UISearchBarDelegate {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if !searchController.isActive {
            print("Cancelled")
        }
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("Okay")
        self.isInEditingMode = true
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isInEditingMode = false
        filteredArray = listingsArray
        showsTableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.searchTextField.text {
            if text == StringKeys.blank {
                filteredArray = listingsArray
                showsTableView.reloadData()
                return
            } else {
                guard let results = listingsViewModel?.performSearchInShow(array: listingsArray, searchString: text) else {return}
                self.filteredArray = results
                showsTableView.reloadData()
            }
            
        }
    }
}

extension ListingsViewController: ListingsProtocol {
    func listingDataFetched(results: [Result]) {
        DispatchQueue.main.async {
            self.showsTableView.isHidden = false
            self.isResponseAvailable = true
            self.listingsArray.append(contentsOf: results)
            self.filteredArray.append(contentsOf: results)
            self.showsTableView.reloadData()
        }
    }
    
    func errorInFetchingListings(type: ErrorType) {
        self.showsTableView.isHidden = true
        self.isResponseAvailable = true
        showError(type: type)
    }
}
