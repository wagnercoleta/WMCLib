//
//  WMCResolverProtocol.swift
//  WMCLib
//
//  Created by Wagner Coleta on 08/07/22.
//

public protocol WMCResolverProtocol {
    func resolver<T>(_ metaType: T.Type) -> T
    func autoResolve<T>() -> T
}
