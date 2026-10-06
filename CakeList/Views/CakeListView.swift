//
//  CakeListView.swift
//  CakeList
//
//  Created by Stefan Grandjean-Thomsen on 22/09/2026.
//

import SwiftUI
import Combine

struct CakeListView<ViewModel: CakeListViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel
    @State private var selectedCake: Cake?

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.viewState {
                case .loading:
                    VStack {
                        ProgressView()
                        Text("Loading cakes...")
                            .foregroundStyle(.secondary)
                    }

                case .loaded(let cakes, let isRefreshing):
                    cakeList(cakes, isRefreshing: isRefreshing)
                case .error(let message):
                    VStack(spacing: 16) {
                        Text("Oops, something went wrong")
                            .font(.headline)

                        Text(message)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        Button(action: {
                            Task {
                                await viewModel.retry()
                            }
                        }) {
                            Text("Try Again")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.blue)
                                .foregroundStyle(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Cakes")
            .sheet(item: $selectedCake) { cake in
                CakeDetailView(cake: cake)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
        .task {
            await viewModel.loadCakes()
        }
    }
    
    fileprivate func cakeList(_ cakes: [Cake], isRefreshing: Bool) -> some View {
        return List {
            if isRefreshing {
                Text("Updating...")
            }
            ForEach(cakes, id: \.id) { cake in
                Button  {
                    selectedCake = cake
                } label: {
                    CakeRowView(cake: cake)
                }
                .listRowSeparator(.visible)
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.refresh()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    Task {
                        await viewModel.refresh()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}

#Preview("Loaded") {
    CakeListView(viewModel: CakeListViewModel.loadedPreview)
}

#Preview("Loading") {
    CakeListView(viewModel: CakeListViewModel.loadingPreview)
}

#Preview("Error") {
    CakeListView(viewModel: CakeListViewModel.errorPreview)
}

#if DEBUG
extension CakeListViewModel {
    @MainActor static let loadedPreview: MockCakeListViewModel = {
        let vm = MockCakeListViewModel()
        vm.viewState = .loaded([
            Cake(title: "Chocolate Cake", desc: "Rich chocolate", image: "https://www.lolas.co.uk/cdn/shop/files/ChocolateandRaspberryDinners_0cacf994-7fe5-468a-b420-bfe00548554f.jpg?v=1773675676"),
            Cake(title: "Vanilla Cake", desc: "Classic vanilla", image: "https://www.lolas.co.uk/cdn/shop/files/ChocolateandRaspberryDinners_0cacf994-7fe5-468a-b420-bfe00548554f.jpg?v=1773675676")
        ], isRefreshing: false)
        return vm
    }()
    
    @MainActor static let loadingPreview: MockCakeListViewModel = {
        let vm = MockCakeListViewModel()
        vm.viewState = .loading
        return vm
    }()
    
    @MainActor static let errorPreview: MockCakeListViewModel = {
        let vm = MockCakeListViewModel()
        vm.viewState = .error("Error")
        return vm
    }()
}

class MockCakeListViewModel: CakeListViewModelProtocol {
    func refresh() async { }
    
    @Published var viewState: ViewState<[Cake]> = .loading
    
    func loadCakes() async {}
    
    func retry() async {}

}
#endif
