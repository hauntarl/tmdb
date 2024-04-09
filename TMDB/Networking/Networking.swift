//
//  Networking.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//
//  Protocol based mocking: https://www.swiftbysundell.com/articles/dependency-injection-and-unit-testing-using-async-await/#:~:text=Protocol%2Dbased%20mocking

import SwiftUI

/**
 A protocol-based Networking abstraction, which essentially just requires us to duplicate the signature of the
 `URLSession.data` method within that protocol, and to then make `URLSession` conform to our new protocol through an
 extension.
 */
protocol Networking {
    func data(from url: URL, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}

/**
 If we want to avoid having to always pass `delegate: nil` at call sites where we're not interested in using a
 delegate, we also have to add the following convenience API (which URLSession itself provides when using it directly)
 */
extension Networking {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await data(from: url, delegate: nil)
    }
}

extension URLSession: Networking {}

/**
 NetworkError enum used for throwing specific network errors.
 */
enum NetworkError: Error {
    case badURL(message: LocalizedStringKey)
    case badImage(message: LocalizedStringKey)
}
