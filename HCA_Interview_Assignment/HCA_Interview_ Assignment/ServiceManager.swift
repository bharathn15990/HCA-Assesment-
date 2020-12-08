//
//  ServiceManager.swift
//  HCA_Interview_ Assignment
//
//  Created by Bharath Nallatheegala on 12/6/20.
//

import Foundation

enum ApplicationError: String, Error {
    case urlError = "Url Error"
    case serviceError = "Service Failure"
    case parsingFailure = "Somthing went wrong with parsing"
    case emptyResults = "No Results found"
}

class ServiceManager {
    
    private let urlString = "https://api.stackexchange.com/2.2/questions?order=desc&max=1607385600&sort=activity&site=stackoverflow"
    
    static let sharedInstance = ServiceManager()
    
    private init() { }
    
    func getResponce(onCompletion:@escaping (Result<QuestionsModel, ApplicationError>) ->Void) {
        
        guard let urlFromString = URL(string: urlString) else {
            onCompletion(.failure(.urlError))
            return
        }
        
        let urlRequest = URLRequest(url: urlFromString)
        let session =  URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard  error == nil, let data = data else {
                onCompletion(.failure(.serviceError))
                return
            }
            if let responceObject = try? JSONDecoder().decode(QuestionsModel.self, from: data) {
                DispatchQueue.main.async {
                    onCompletion(.success(responceObject))
                }
            } else {
                DispatchQueue.main.async {
                    onCompletion(.failure(.parsingFailure))
                }
            }
        }
        dataTask.resume()
    }
    
}
