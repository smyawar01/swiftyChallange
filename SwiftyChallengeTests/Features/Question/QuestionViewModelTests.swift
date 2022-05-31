//
//  QuestionViewModelTests.swift
//  SwiftyChallengeTests
//
//  Created by Yawar Ali on 30/05/2022.
//  Copyright © 2022 Monish Syed . All rights reserved.
//

import XCTest
@testable import SwiftyChallenge

class QuestionViewModelTests: XCTestCase {
    
    func test_loadQuestion_successfully() throws {
        
        var sut: QuestionViewModel = makeQuestionViewModel(success: true)
        expectation { expectation in
            
            sut.onChangeState = { state in
                
                switch state {
                    
                case .loaded(_):
                    
                    XCTAssertEqual(sut.count(), 2)
                    expectation.fulfill()
                default:
                    XCTFail()
                }
            }
            sut.load()
        }
    }
    func test_loadQuestion_failure() throws {
        
        var sut: QuestionViewModel = makeQuestionViewModel(success: false)
        expectation { expectation in
            
            sut.onChangeState = { state in
                
                switch state {
                    
                case .error:
                    
                    XCTAssertEqual(sut.count(), 0)
                    expectation.fulfill()
                default:
                    XCTFail()
                }
            }
            sut.load()
        }
    }
    
    func makeQuestionViewModel(success: Bool) -> QuestionViewModel {
        
        let repo = QuestionRespoitoryStub(success: success)
        let questionVM = QuestionViewModelImpl(questionRepo: repo)
        return questionVM
    }
}

struct QuestionRespoitoryStub: QuestionRepository {
    
    var success = true
    
    func getAll(completionHandler: @escaping (Result<[Question], Error>) -> Void) {
        guard success else {
            completionHandler(.failure(Mocker.StubError.fake))
            return
        }
        let questions = [Question(query: "Given : var stringValue:String = “Justin Gif”. What is the result of stringValue = nil?",
                                  answers: [
                                    Question.Answer(title: "stringValue == nil", correct: false),
                                    Question.Answer(title: "the compiler won't allow it", correct: true),
                                    Question.Answer(title: "stringValue == “Justin Gif”", correct: false),
                                    Question.Answer(title: "None", correct: false)
                                  ]),
                         Question(query: "How do you declare a mutable Integer array?",
                                  answers: [
                                    Question.Answer(title: "let arr = [Int]()", correct: false),
                                    Question.Answer(title: "var arr: [Int] = []", correct: true),
                                    Question.Answer(title: "var arr: [Int?]", correct: false),
                                    Question.Answer(title: "Both 2nd & 3rd", correct: false)
                                  ])
        ]
        completionHandler(.success(questions))
    }
}
