//
//  ListingsViewModel.swift
//  Shows
//
//  Created by Taral Rathod on 30/04/21.
//

import Foundation

enum ErrorType {
    case dataNotAvailable
    case errorOccoured
    case noResultFound
}

protocol ListingsProtocol: AnyObject {
    func listingDataFetched(results: [Result])
    func errorInFetchingListings(type: ErrorType)
}

class ListingsViewModel {
    weak var delegate: ListingsProtocol?

    required init(delegate: ListingsProtocol) {
        self.delegate = delegate
    }

    func getShowsList(page: Int) {
        let listingsEndpoint = String(format: NetworkConstants.listingsEndPoint, KeyConstants.apiKey, String(page))
        let urlString = NetworkConstants.baseURL + listingsEndpoint
        guard let url = URL(string: urlString) else {return}
        DataTaskManager.executeRequest(For: url, httpMethod: RequestTypes.GET.rawValue) { [weak self] (responseData, error) in
            if error == nil {
                guard let response = responseData else {return}
                self?.convertDataToListingsModel(response: response)
            } else {
                self?.delegate?.errorInFetchingListings(type: .errorOccoured)
            }
        }
    }

    private func convertDataToListingsModel(response: Data) {
//        do{
//            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String : Any]
//            print(json ?? "")
//        } catch { print("erroMsg") }
        do {
            let decoder = JSONDecoder()
            let dataModel = try decoder.decode(ListModel.self, from: response)
            self.getDisplayValues(model: dataModel)
            print(dataModel)
        } catch {
            print(error)
        }
    }

    private func getDisplayValues(model: ListModel) {
        guard let results = model.results else {
            self.delegate?.errorInFetchingListings(type: .dataNotAvailable)
            return
        }

        if results.count > 0 {
            delegate?.listingDataFetched(results: results)
        } else {
            delegate?.errorInFetchingListings(type: .dataNotAvailable)
        }
    }

    func performSearchInShow(array: [Result], searchString: String) -> [Result] {
        let filteredArray = array.filter { (result) -> Bool in
            if let title = result.title {
                let array = title.split(separator: " ")
                let searchArray = searchString.split(separator: " ")
                if array.count > 0 {
                    for element in array {
                        for word in searchArray where element.contains(word) {
                            return true
                        }
                    }
                }
            }
            return false
        }

        return filteredArray
    }
}
