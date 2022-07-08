//
//  WMCConteinerProtocol.swift
//  WMCLib
//
//  Created by Wagner Coleta on 08/07/22.
//

public protocol WMCConteinerProtocol {
    func register<T>(instance: T, forMetaType metaType: T.Type)
    func register<T>(
        factory: @escaping (WMCResolverProtocol) -> T,
        forMetaType metaType: T.Type
    )
}

extension WMCConteinerProtocol {
    func register<T>(
        factory: @escaping () -> T,
        forMetaType metaType: T.Type
        ) {
        self.register(
            factory: { _ in factory() },
            forMetaType: metaType)
    }
}
