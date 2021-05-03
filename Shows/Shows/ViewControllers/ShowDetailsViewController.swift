//
//  ShowDetailsViewController.swift
//  Shows
//
//  Created by Taral Rathod on 01/05/21.
//

import UIKit

enum DetailsSections: String {
    case details
    case cast
    case suggestion
    case reviews
}

class ShowDetailsViewController: UIViewController {

    @IBOutlet weak var detailsTableView: UITableView!

    private var sections = [DetailsSections]()
    private var reviewsArray = [Results]()
    private var synopsis: SynopsisModel?
    private var casts: [Cast]?
    private var suggestion: [SuggestionResult]?
    private var results: [Results]?
    private var detailsViewModel: ShowDetailsViewModel?
    private var isSynopsisReceived = false
    private var isReviewReceived = false
    private var isCreditsReceived = false
    private var isSuggestionReceived = false
    var movieId: String?

    static func initializeFromStoryboard() -> ShowDetailsViewController? {
        let storyboard = UIStoryboard(name: StoryboardConstants.mainStoryboard,
                                      bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.detailsScreen) as? ShowDetailsViewController
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = StringKeys.detailsScreenTitle
        sections = [.details, .cast, .reviews, .suggestion]
        setupTableView()
        fetchData()
    }

    private func setupTableView() {
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.rowHeight = UITableView.automaticDimension
        detailsTableView.estimatedRowHeight = 72
        detailsTableView.tableFooterView = UIView()
    }

    private func fetchData() {
        guard let movieId = movieId else {return}
        detailsViewModel = ShowDetailsViewModel(delegate: self)
        detailsViewModel?.getAllDetailsFor(movieId: movieId)
    }

}

extension ShowDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if !isSynopsisReceived && !isCreditsReceived && !isReviewReceived && !isSuggestionReceived {
            return 4
        }
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section] == .reviews {
            return isReviewReceived ? reviewsArray.count : 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detailsSections = sections[indexPath.section]
        switch detailsSections {
        case .details:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCellConstants.detailsCell, for: indexPath) as? DetailsViewCell else {return UITableViewCell()}
            if !isSynopsisReceived {
                cell.startAnimation()
            } else {
                cell.stopAnimation()
                guard let model = synopsis else {return UITableViewCell()}
                cell.setupUI(model: model)
            }
            return cell
        case .cast:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCellConstants.creditsCell, for: indexPath) as? CastingAndSuggestionCell else {return UITableViewCell()}
            if !isCreditsReceived {
                cell.setupContent(array: [String](), isContentReceived: false)
            } else {
                guard let cast = casts else {return UITableViewCell()}
                cell.setupContent(array: cast, isContentReceived: true)
            }
            return cell
        case .reviews:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCellConstants.reviewCell, for: indexPath) as? ReviewsCell else {return UITableViewCell()}
            if !isReviewReceived {
                cell.startAnimation()
            } else {
                cell.stopAnimation()
                if reviewsArray.count > 0 {
                    let result = reviewsArray[indexPath.row]
                    cell.setupUI(result: result)
                }
            }
            return cell
        case .suggestion:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCellConstants.creditsCell, for: indexPath) as? CastingAndSuggestionCell else {return UITableViewCell()}
            if !isSuggestionReceived {
                cell.setupContent(array: [String](), isContentReceived: false)
            } else {
                guard let suggestions = suggestion else {return UITableViewCell()}
                cell.setupContent(array: suggestions, isContentReceived: true)
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].rawValue
    }
}

extension ShowDetailsViewController: ShowDetailsProtocol {
    func synopsisReceived(synopsis: SynopsisModel) {
        isSynopsisReceived = true
        self.synopsis = synopsis
//        let index = sections.firstIndex(of: .details)
        DispatchQueue.main.async {
//            self.detailsTableView.reloadSections(IndexSet(integer: index ?? 0), with: .none)
            self.detailsTableView.reloadData()
        }
    }
    
    func creditsReceived(cast: [Cast]) {
        isCreditsReceived = true
        casts = cast
//        let index = sections.firstIndex(of: .cast)
        DispatchQueue.main.async {
//            self.detailsTableView.reloadSections(IndexSet(integer: index ?? 0), with: .none)
            self.detailsTableView.reloadData()
        }
    }
    
    func suggestionReceived(suggestions: [SuggestionResult]) {
        isSuggestionReceived = true
        suggestion = suggestions
//        let index = sections.firstIndex(of: .suggestion)
        DispatchQueue.main.async {
//            self.detailsTableView.reloadSections(IndexSet(integer: index ?? 0), with: .none)
            self.detailsTableView.reloadData()
        }
    }
    
    func reviewsReceived(result: [Results]) {
        isReviewReceived = true
        reviewsArray = result
//        let index = sections.firstIndex(of: .reviews)
        DispatchQueue.main.async {
//            self.detailsTableView.reloadSections(IndexSet(integer: index ?? 0), with: .none)
            self.detailsTableView.reloadData()
        }
    }
    
    func errorInSynopsisData() {
        print("Error In synopsis")
    }
    
    func errorInCreditsData() {
        print("Error In Credits")
    }
    
    func errorInSuggestionData() {
        print("Error In Suggestions")
    }
    
    func errorInReviewsData() {
        print("Error In Reviews")
    }
    
    
}
