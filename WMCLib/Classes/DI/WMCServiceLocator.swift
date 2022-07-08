//
//  WMCServiceLocator.swift
//  WMCLib
//
//  Created by Wagner Coleta on 08/07/22.
//

import Foundation

public final class WMCServiceLocator {
    public static let shared: WMCServiceLocatorProtocol = WMCServiceLocator()
    
    private final class LazyInstanceWrapper {
        let instance: Any
        init(instance: Any) {
            self.instance = instance
        }
    }
    
    private var instances: [String: Any] = [:]
    private var lazyInstances: NSMapTable<NSString, LazyInstanceWrapper> = .init(
        keyOptions: .strongMemory,
        valueOptions: .weakMemory
    )
    
    private typealias LazyDependencyFactory = () -> Any
    private var factories: [String: LazyDependencyFactory] = [:]
    
    private func getKey<T>(for metaType: T.Type) -> String {
        let key = String(describing: T.self)
        return key
    }
}

extension WMCServiceLocator {
    private func getInstance<T>(formMetaType: T.Type) -> T? {
        let key = getKey(for: T.self)
        if let instance = instances[key] as? T {
            return instance
        } else if let lazyInstance = getLazyInstance(for: T.self, key: key) {
            return lazyInstance
        } else {
            return nil
        }
    }
    
    private func getLazyInstance<T>(for _: T.Type, key: String) -> T? {
        let objectKey = key as NSString
        
        if let instanceInMemory = lazyInstances.object(forKey: objectKey)?.instance as? T {
            return instanceInMemory
        }
        
        guard
            let factory: LazyDependencyFactory = factories[key],
            let newInstance = factory() as? T
        else { return nil }
        
        let wrappedInstance = LazyInstanceWrapper(instance: newInstance)
        lazyInstances.setObject(wrappedInstance, forKey: objectKey)
        
        return newInstance
    }
}

extension WMCServiceLocator: WMCConteinerProtocol {
    public func register<T>(instance: T, forMetaType metaType: T.Type) {
        let key = getKey(for: metaType)
        guard instances[key] == nil else {
            fatalError("[register] \(WMCConstants.mesmaInstanciaError) (\(key))")
        }
        instances[key] = instance
    }
    
    public func register<T>(factory: @escaping (WMCResolverProtocol) -> T, forMetaType metaType: T.Type) {
        let key = getKey(for: metaType)
        guard factories[key] == nil else {
            fatalError("[register factory] \(WMCConstants.mesmaInstanciaError) (\(key))")
        }
        factories[key] = { factory(self) }
    }
}

extension WMCServiceLocator: WMCResolverProtocol {
    public func resolver<T>(_ metaType: T.Type) -> T {
        guard let instance = getInstance(formMetaType: T.self) else {
            fatalError("[resolver] \(WMCConstants.naoExisteInstanciaError) `\(getKey(for: T.self))`")
        }
        return instance
    }
    
    public func autoResolve<T>() -> T {
        guard let instance = getInstance(formMetaType: T.self) else {
            fatalError("[autoResolve] \(WMCConstants.naoExisteInstanciaError) `\(getKey(for: T.self))`")
        }
        return instance
    }
}
