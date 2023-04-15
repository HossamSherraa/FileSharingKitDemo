//
//  Delegate.swift
//  FilesharingLocalServer
//
//  Created by Hossam on 08/04/2023.
//

import Foundation
import FileSharingKit
import SwiftUI
 
public struct DefaultServerDelegate : ServerDelegate {
    public init(){}
    
    public typealias Event = ServerFolderEvent<Folder>
    public func handel(event: Event) async throws {
        try await event.handle()
    }
}
