//
//  DataTaskManager.swift
//  Shows (iOS)
//
//  Created by Taral Rathod on 28/04/21.
//

import Foundation

struct DataTaskManager {
    static func executeRequest(For url: URL, httpMethod: String, completion: @escaping (_ responseData: Data?, _ error: Error? ) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        request.httpMethod = httpMethod
        let task: URLSessionDataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error == nil {
                guard let data = data else {print("No Data"); return}
                completion(data, nil)
            } else {
                completion(nil, error)
            }
        })
        task.resume()
    }
}
