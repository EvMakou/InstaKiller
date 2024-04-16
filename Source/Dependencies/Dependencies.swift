//
//  Dependencies.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import Foundation

class Dependencies {
    fileprivate static var root = Dependencies()
    private var factories = [String: () -> Any]()
    
    static func prepare() -> Dependencies {
        Dependencies.root
    }
    
    func register<T>(_ factory: @escaping () -> T) {
        let key = keysFrom(type: T.self)
        factories[key] = factory
    }
}

private extension Dependencies {
    func resolve<T>() -> T {
        let key = keysFrom(type: T.self)
        guard let component = factories.first(where: { $0.key.contains(key) })?.value() as? T else {
            fatalError("Dependency '\(T.self)' not registered!")
        }
        return component
    }
    
    func keysFrom<T>(type: T) -> String {
        String(describing: type.self).split(separator: "&").map({ $0.trimmingCharacters(in: .whitespaces) }).joined(separator: "_")
    }
}

@propertyWrapper
struct Injected<Value> {
    let wrappedValue: Value

    init() {
        wrappedValue = Dependencies.root.resolve()
    }
}
