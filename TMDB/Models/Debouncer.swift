//
//  Debouncer.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/12/24.
//
//  Code snippet for Debouncer is inspired from Pro SwiftUI book authored by
//  Paul Hudson.

import Combine
import SwiftUI

/**
 A generic debouncer that works on bindings.
 */
final class Debouncer<T>: ObservableObject {
    @Published var input: T
    @Published var output: T
    
    private var debounce: AnyCancellable?
    
    init(initialValue: T, delay: Double = 1) {
        self.input = initialValue
        self.output = initialValue
        
        debounce = $input
            .debounce(for: .seconds(delay), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.output = $0
            }
    }
}

