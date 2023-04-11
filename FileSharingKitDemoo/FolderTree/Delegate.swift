//
//  Delegate.swift
//  FilesharingLocalServer
//
//  Created by Hossam on 08/04/2023.
//

import Foundation
import FileSharingKit
import SwiftUI
 
struct DefaultServerDelegate : ServerDelegate {
   
    
    typealias Event = ServerFolderEvent<Folder>
    func handel(event: Event) async throws {
        try await event.handle()
    }
}
