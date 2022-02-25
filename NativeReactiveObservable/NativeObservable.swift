//
//  NativeObservable.swift
//  NativeReactiveObserver
//
//  Created by Giovanne Bressam on 03/10/21.
//

import Foundation

class Observable<T> {
    var value: T? {
        didSet {
            self.observerClosure?(value)
        }
    }

    init(value: T?) {
        self.value = value
    }
    
    private var observerClosure: ((T?) -> Void)?
    
    func add(_ observerBlock: @escaping (T?) -> Void) {
        self.observerClosure = observerBlock
    }
}
