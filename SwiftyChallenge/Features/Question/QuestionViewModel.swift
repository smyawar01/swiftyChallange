//
//  QuestionViewModel.swift
//  SwiftyChallenge
//
//  Created by Yawar Ali on 30/05/2022.
//  Copyright © 2022 Monish Syed . All rights reserved.
//

import Foundation

enum QuestionViewState {
    
    case error
    case loaded(Question)
    case answered(String, String)
}

protocol QuestionViewModel {
    
    var questions: [Question] { get set }
    var onChangeState: ((QuestionViewState) -> Void)? { get set }
    func load()
    func submit(choice: Int)
    func count() -> Int
}

final class QuestionViewModelImpl: QuestionViewModel {
    
    var onChangeState: ((QuestionViewState) -> Void)?
    var questions: [Question] = []
    let questionRepo: QuestionRepository
    var selectedQuestionIndex: Int = -1
    init(questionRepo: QuestionRepository) {
        
        self.questionRepo = questionRepo
    }
    
    func load() {
        
        self.questionRepo.getAll { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let questions):
                
                self.questions = questions
                if let question = self.questions.randomElement() {
                    
                    self.selectedQuestionIndex = self.questions.firstIndex(of: question) ?? -1
                    self.update(state: .loaded(question))
                } else {
                    
                    self.update(state: .error)
                }
            case .failure(_):
                self.update(state: .error)
            }
        }
    }
    func submit(choice: Int) {
        
        let question = self.questions[self.selectedQuestionIndex]
        let index = question.answers.firstIndex(where: { $0.correct == true })
        var state: QuestionViewState = .answered("Error!", "You gave a wrong answer.")
        if choice == index {
            
            state = .answered("Congratulations!", "You gave a correct answer.")
        }
        self.update(state: state)
    }
    func count() -> Int {
        
        return self.questions.count
    }
}
extension QuestionViewModel {
    
    func update(state: QuestionViewState) {
        
        DispatchQueue.main.async {
            
            self.onChangeState?(state)
        }
    }
}
