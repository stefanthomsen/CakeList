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
    func refresh() async
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
            let cakes = try await load()
            viewState = .loaded(cakes, isRefreshing: false)
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }
    
    @MainActor
    func retry() async {
        await loadCakes()
    }
    
    @MainActor
    func refresh() async {
        if case .loaded(let cakes, _) = viewState {
            viewState = .loaded(cakes, isRefreshing: true)
        } else {
            viewState = .loading
        }
        
        do {
            let cakes = try await load()
            viewState = .loaded(cakes, isRefreshing:false)
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }
    
    private func load() async throws -> [Cake] {
        let cakes = try await service.fetchCakes()
        return cakes.sorted { $0.title.lowercased() < $1.title.lowercased() }
    }
}
