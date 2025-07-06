//
//  AerospaceModesRepository.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 04/07/2025.
//

import Foundation
import Combine

struct AerospaceModesState {
    let modes: [String]
    var current: Int?
}

protocol AerospaceModesRepository {
    var modesState: AerospaceModesState { get }
    var modesStatePublisher: AnyPublisher<AerospaceModesState, Never> { get }
}
