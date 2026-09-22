//
//  ViewState.swift
//  CakeList
//
//  Created by Stefan Grandjean-Thomsen on 22/09/2026.
//

enum ViewState<T> {
    case loading
    case loaded(T)
    case error(String)
}
