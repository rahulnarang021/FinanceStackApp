//
//  AppInitApiWrapper.swift
//  FinanceStackAppTests
//
//  Created by RN on 15/05/21.
//

import Foundation

public class APIManager: APIManagerInput {// Class to make API Call

    public init() { }
    public func makeAPICall<T: Decodable>(apiConfiguration: APIConfiguration, completion: @escaping ((Swift.Result<T, APIError>) -> Void)) {
        var request = URLRequest(url: apiConfiguration.getUrl().getURLAddingGetParams(params: apiConfiguration.getGetParams()), cachePolicy: .reloadIgnoringCacheData, timeoutInterval: apiConfiguration.getRequestTimeout())

        let urlSession = URLSession.shared
        request.httpMethod = apiConfiguration.getRequestType().rawValue
        if let postparams = apiConfiguration.getPostParams() {
            let jsonData = try? JSONSerialization.data(withJSONObject: postparams)
            request.httpBody = jsonData
        }

        request.addValue(ApiConstants.applicationJson, forHTTPHeaderField: ApiConstants.contentType)
        request.addValue(ApiConstants.applicationJson, forHTTPHeaderField: ApiConstants.accept)
        if let headers = apiConfiguration.getHeaders(), headers.count > 0 {
            for apiHeader in headers {
                request.addValue(apiHeader.value, forHTTPHeaderField: apiHeader.key)
            }
        }
        do {
            let task = urlSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse, httpResponse.isSuccess(), let jsonData = data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let response: T = try jsonDecoder.decode(T.self, from: jsonData)// decode data
                        DispatchQueue.main.async {
                            completion(.success(response))
                        }
                    } catch {// not handling error would be used to log somewhere
                        DispatchQueue.main.async {
                            completion(.failure(APIError(message: ApiConstants.parsingError)))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(APIError(error: error)))
                    }
                }
            }
            task.resume()
        }
    }
}
