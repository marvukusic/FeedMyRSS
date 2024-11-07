//
//  EnvironmentValues+Extensions.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 07.11.2024..
//

import SwiftUI

struct NetworkServiceKey: EnvironmentKey {
    static let defaultValue: NetworkServiceProtocol = NetworkService()
}

extension EnvironmentValues {
    var networkService: NetworkServiceProtocol {
        get { self[NetworkServiceKey.self] }
        set { self[NetworkServiceKey.self] = newValue }
    }
}
