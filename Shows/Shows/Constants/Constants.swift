//
//  Constants.swift
//  Shows (iOS)
//
//  Created by Taral Rathod on 28/04/21.
//

import Foundation

struct NetworkConstants {
    static let baseURL = "https://api.themoviedb.org/3/movie/"
    static let listingsEndPoint = "now_playing?api_key=%@&language=en-US&page=%@"
    static let synopsisEndPoint = "%@?api_key=%@&language=en-US"
    static let reviewsEndpoint = "%@/reviews?api_key=%@&language=en-US"
    static let creditsEndpoint = "%@/credits?api_key=%@&language=en-US"
    static let suggestionEndPoint = "%@/similar?api_key=%@&language=en-US"
}

struct KeyConstants {
    static let apiKey = "38f845a7c164d0e74ee2a26d95b298a8"
    static let imageBaseUrl = "https://image.tmdb.org/t/p/w500/%@"
    static let castImageBaseUrl = "https://image.tmdb.org/t/p/original/%@"
}

struct StringKeys {
    static let blank = ""
    static let space = " "
    static let dataMessage = "No shows available at this time."
    static let errorMessage = "Something went wrong while fetching shows, please try after sometime."
    static let noSearchResult = "No search result found."
    static let releasedOn = "Released On: %@"
    static let detailsScreenTitle = "Show Details"
}

struct TableCellConstants {
    static let listingCell = "listingViewCell"
    static let creditsCell = "castingAndSuggestionCell"
    static let detailsCell = "detailsViewCell"
    static let reviewCell = "reviewsCell"
    static let castingCollectionCell = "collectionCell"
}

struct StoryboardConstants {
    static let mainStoryboard = "Main"
    static let detailsScreen = "showDetailsViewController"
}

enum RequestTypes: String {
    case GET
    case POST
    case PUT
    case DELETE
}
