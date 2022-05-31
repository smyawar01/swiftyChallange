//
//  QuestionRepoImpl.swift
//  SwiftyChallengeTests
//
//  Created by Yawar Ali on 30/05/2022.
//  Copyright © 2022 Monish Syed . All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftyChallenge

final class QuestionRepositoryTests: XCTestCase {

    private var sut: QuestionRepository!
    private let repository = QuestionRemoteRepositoryStub()
    
    override func setUp() {
        super.setUp()
        sut = QuestionRepositoryImpl(questionRepoRemote: repository)
    }
    
    func testSuccess() {
        expectation { expectation in
            self.sut.getAll { result in
                switch result {
                case .success(let questions):
                    let expected = [Question]()

                    XCTAssertEqual(questions, expected)
                    expectation.fulfill()
                case .failure(_):
                    XCTFail()
                }
            }
        }
    }
    
    func testFailure() {
        repository.success = false
        
        expectation { expectation in
            self.sut.getAll { result in
                switch result {
                case .success(_):
                    XCTFail()
                case .failure(let error):
                    XCTAssertEqual(error as! Mocker.StubError, Mocker.StubError.fake)
                    expectation.fulfill()
                }
            }
        }
        
    }
    
}

private final class QuestionRemoteRepositoryStub: QuestionRepository {
    
    var success = true
    
    func getAll(completionHandler: @escaping (Result<[Question], Error>) -> Void) {
        guard success else {
            completionHandler(.failure(Mocker.StubError.fake))
            return
        }
        
        completionHandler(.success([]))
    }
}

extension XCTestCase {
    
    func expectation(timeout: TimeInterval = 1.0,
                     handler: @escaping (XCTestExpectation) -> Void) {
        let expectation = XCTestExpectation(description: "com.careem.app.async.expectation")
        handler(expectation)
        wait(for: [expectation], timeout: timeout)
    }
}



