//
//  QuestionFactory.swift
//  SwiftyChallenge
//
//  Created by Yawar Ali on 30/05/2022.
//  Copyright © 2022 Monish Syed . All rights reserved.
//

import Foundation

struct QuestionFactory {
    
    let service = NetworkService()
    
    func makeModel() -> some QuestionViewModel {
        
        return QuestionViewModelImpl(questionRepo: makeQuestionRepository())
    }
}

private extension QuestionFactory {
    
    private func makeQuestionRepository() -> QuestionRepository {
        
        let remoteRepository = QuestionRepositoryRemote(networkService: service)
        return QuestionRepositoryImpl(questionRepoRemote: remoteRepository)
    }
}
