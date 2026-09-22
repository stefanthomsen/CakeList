//
//  CakeListViewModel.swift
//  CakeList
//
//  Created by Stefan Grandjean-Thomsen on 22/09/2026.
//

import Foundation
import SwiftUI
import Combine

protocol CakeListViewModelProtocol: ObservableObject {
    var viewState: ViewState<[Cake]> { get }
    
    func loadCakes() async
    func retry() async
}

final class CakeListViewModel: CakeListViewModelProtocol {
    @Published var viewState: ViewState<[Cake]> = .loading
    
    private let service: CakeServiceProtocol
    
    init(service: CakeServiceProtocol = CakeService()) {
        self.service = service
    }
    
    @MainActor
    func loadCakes() async {
        viewState = .loading
        
        do {
            let cakes = try await service.fetchCakes()
            let sortedCakes = cakes.sorted { $0.title.lowercased() < $1.title.lowercased() }
            viewState = .loaded(sortedCakes)
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }
    
    @MainActor
    func retry() async {
        await loadCakes()
    }
}
