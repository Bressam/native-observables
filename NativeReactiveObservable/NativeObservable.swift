//
//  NativeObservable.swift
//  NativeReactiveObserver
//
//  Created by Giovanne Bressam on 03/10/21.
//

import Foundation

/// Reactive observable object that observers can bind actions to be executed on value change
/// If need any more complex behavior, such as zip, concat, completables, or any other kind  is easier to use combine or some third party reactive library, such as RxSwift or ReactiveCocoa
class Observable<T> {
    private typealias Observer = ((T) -> Void)
    private var observers: [Observer] = []
    private var observersOnMain: [Observer] = []
    
    /// Triggers all observers on value change
    var value: T {
        didSet {
            observers.forEach{ $0(self.value) }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.observersOnMain.forEach{ $0(self.value) }
            }
        }
    }

    init(_ value: T) {
        self.value = value
    }
    
    /// Subscribe to observe to values change
    func subscribe(_ observerBlock: @escaping (T) -> Void) {
        observers.append(observerBlock)
    }
    
    /// Subscribe to observe to values change and observer block is executed on main thread
    func subscribeOnMain(_ observerBlock: @escaping (T) -> Void) {
        observersOnMain.append(observerBlock)
    }
}
