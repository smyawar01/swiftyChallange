//
//  Mocker.swift
//  SwiftyChallengeTests
//
//  Created by Yawar Ali on 30/05/2022.
//  Copyright © 2022 Monish Syed . All rights reserved.
//

import Foundation

enum Mocker {
    
    struct EmptyResponse: Decodable {}
    enum StubError: Error {
        case fake
    }
}
