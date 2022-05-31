//
//  QuestionRepository.swift
//  SwiftyChallenge
//
//  Created by Yawar Ali on 30/05/2022.
//  Copyright © 2022 Monish Syed . All rights reserved.
//

import Foundation

protocol QuestionRepository {
    
    typealias completion = (Result<[Question], Error>) -> Void
    func getAll(completionHandler: @escaping completion)
}

struct QuestionRequest: Request {
    var urlRequest: URLRequest
}

struct QuestionRepositoryImpl: QuestionRepository {
    
    let questionRepoRemote: QuestionRepository
    
    func getAll(completionHandler: @escaping completion) {
        
        self.questionRepoRemote.getAll(completionHandler: completionHandler)
    }
}

struct QuestionRepositoryRemote: QuestionRepository {
    
    let networkService: NetworkService
    func getAll(completionHandler: @escaping completion) {
        
        let url = URL(string: "https://gist.githubusercontent.com/monishsyed/7d38bbe2e512ccc2c3708168b99ff5e5/raw/6a967af106fc951979342a4a7bbdb45d8aedc845/SwiftChallenge.json")
        
        guard let url = url else {
            
            return completionHandler(.failure(NetworkService.ServiceError.invalidUrl))
        }
        let request =  QuestionRequest(urlRequest: URLRequest(url: url))
        self.networkService.get(request: request) { result in
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
                break
            case .success(let data):

                let jsonDecoder = JSONDecoder()
                do {

                    let response = try jsonDecoder.decode(QuestionResponse.self, from: data)
                    completionHandler(.success(response.questions))
                } catch (_) {

                    completionHandler(.failure(NetworkService.ServiceError.invalidJson))
                }
            }
        }
    }
}
