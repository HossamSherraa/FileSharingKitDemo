//
//  Delegate.swift
//  FilesharingLocalServer
//
//  Created by Hossam on 08/04/2023.
//

import Foundation
import FileSharingKit
import SwiftUI
struct DemoSharingFolderDelegate : SharingFolderDelegate{
    typealias F =  Folder
    func viewControllerFor(server: ServerReciever<Folder>) -> UIViewController {
        UIHostingController(rootView: SharedFolderView(server: server))
    }
}
