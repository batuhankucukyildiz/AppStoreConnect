//
//  MockError.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 9.04.2026.
//

import Foundation

enum MockError: Error, LocalizedError {
    case sample

    var errorDescription: String? {
        "Mock error"
    }
}
