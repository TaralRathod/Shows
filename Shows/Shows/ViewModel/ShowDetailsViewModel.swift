//
//  ShowDetailsViewModel.swift
//  Shows
//
//  Created by Taral Rathod on 01/05/21.
//

import Foundation

protocol ShowDetailsProtocol: AnyObject {
    func synopsisReceived(synopsis: SynopsisModel)
    func creditsReceived(cast: [Cast])
    func suggestionReceived(suggestions: [SuggestionResult])
    func reviewsReceived(result: [Results])
    func errorInSynopsisData()
    func errorInCreditsData()
    func errorInSuggestionData()
    func errorInReviewsData()
}

class ShowDetailsViewModel {
    weak var delegate: ShowDetailsProtocol?

    required init(delegate: ShowDetailsProtocol) {
        self.delegate = delegate
    }

    func getSynopsis(movieId: String) {
        let synopsisEndpoint = String(format: NetworkConstants.synopsisEndPoint, movieId, KeyConstants.apiKey)
        let urlString = NetworkConstants.baseURL + synopsisEndpoint
        guard let url = URL(string: urlString) else {return}
        DataTaskManager.executeRequest(For: url, httpMethod: RequestTypes.GET.rawValue) { [weak self] (responseData, error) in
            if error == nil {
                guard let response = responseData else {
                    self?.delegate?.errorInSynopsisData()
                    return
                }
                self?.convertDataToSynopsisModel(response: response)
            } else {
                self?.delegate?.errorInSynopsisData()
            }
        }
    }

    private func convertDataToSynopsisModel(response: Data) {
//        do{
//            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String : Any]
//            print(json ?? "")
//        } catch { print("erroMsg") }
        do {
            let decoder = JSONDecoder()
            let dataModel = try decoder.decode(SynopsisModel.self, from: response)
            self.delegate?.synopsisReceived(synopsis: dataModel)
            print(dataModel)
        } catch {
            delegate?.errorInSynopsisData()
            print(error)
        }
    }

    func getCredits(movieId: String) {
        let creditsEndpoint = String(format: NetworkConstants.creditsEndpoint, movieId, KeyConstants.apiKey)
        let urlString = NetworkConstants.baseURL + creditsEndpoint
        guard let url = URL(string: urlString) else {return}
        DataTaskManager.executeRequest(For: url, httpMethod: RequestTypes.GET.rawValue) { [weak self] (responseData, error) in
            if error == nil {
                guard let response = responseData else {
                    self?.delegate?.errorInCreditsData()
                    return
                }
                self?.convertDataToCreditsModel(response: response)
            } else {
                self?.delegate?.errorInCreditsData()
            }
        }
    }

    private func convertDataToCreditsModel(response: Data) {
//        do{
//            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String : Any]
//            print(json ?? "")
//        } catch { print("erroMsg") }
        do {
            let decoder = JSONDecoder()
            let dataModel = try decoder.decode(CreditsModel.self, from: response)
            guard let cast = dataModel.cast else {
                delegate?.errorInCreditsData()
                return
            }
            delegate?.creditsReceived(cast: cast)
            print(dataModel)
        } catch {
            delegate?.errorInCreditsData()
            print(error)
        }
    }

    func getSuggestions(movieId: String) {
        let suggestionEndpoint = String(format: NetworkConstants.suggestionEndPoint, movieId, KeyConstants.apiKey)
        let urlString = NetworkConstants.baseURL + suggestionEndpoint
        guard let url = URL(string: urlString) else {return}
        DataTaskManager.executeRequest(For: url, httpMethod: RequestTypes.GET.rawValue) { [weak self] (responseData, error) in
            if error == nil {
                guard let response = responseData else {
                    self?.delegate?.errorInSuggestionData()
                    return
                }
                self?.convertDataToSuggestionModel(response: response)
            } else {
                self?.delegate?.errorInSuggestionData()
            }
        }
    }

    private func convertDataToSuggestionModel(response: Data) {
//        do{
//            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String : Any]
//            print(json ?? "")
//        } catch { print("erroMsg") }
        do {
            let decoder = JSONDecoder()
            let dataModel = try decoder.decode(SimillarMoviesModel.self, from: response)
            guard let suggestions = dataModel.results else {
                delegate?.errorInSuggestionData()
                return
            }
            delegate?.suggestionReceived(suggestions: suggestions)
            print(dataModel)
        } catch {
            delegate?.errorInSuggestionData()
            print(error)
        }
    }

    func getReviews(movieId: String) {
        let reviewsEndpoint = String(format: NetworkConstants.reviewsEndpoint, movieId, KeyConstants.apiKey)
        let urlString = NetworkConstants.baseURL + reviewsEndpoint
        guard let url = URL(string: urlString) else {return}
        DataTaskManager.executeRequest(For: url, httpMethod: RequestTypes.GET.rawValue) { [weak self] (responseData, error) in
            if error == nil {
                guard let response = responseData else {
                    self?.delegate?.errorInReviewsData()
                    return
                }
                self?.convertDataToReviewsModel(response: response)
            } else {
                self?.delegate?.errorInReviewsData()
            }
        }
    }

    private func convertDataToReviewsModel(response: Data) {
//        do{
//            let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String : Any]
//            print(json ?? "")
//        } catch { print("erroMsg") }
        do {
            let decoder = JSONDecoder()
            let dataModel = try decoder.decode(ReviewsModel.self, from: response)
            guard let result = dataModel.results else {
                delegate?.errorInReviewsData()
                return
            }
            delegate?.reviewsReceived(result: result)
            print(dataModel)
        } catch {
            delegate?.errorInReviewsData()
            print(error)
        }
    }

    func getAllDetailsFor(movieId: String) {
        getSynopsis(movieId: movieId)
        getCredits(movieId: movieId)
        getSuggestions(movieId: movieId)
        getReviews(movieId: movieId)
    }
}
