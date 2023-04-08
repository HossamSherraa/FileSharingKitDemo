//
//  FilesharingLocalServerApp.swift
//  FilesharingLocalServer
//
//  Created by macbook air on 18/03/2023.
//

import SwiftUI
import FileSharingKit
@main
struct FilesharingLocalServerApp: App {
    @State var isConnectPresented : Bool = false
    @State var isServerPresented : Bool = false
    let sharing = FileSharing<Folder>()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                List{
                    Button("Connect") {
                        isConnectPresented.toggle()
                    }
                    
                    Button("Server") {
                        isServerPresented.toggle()
                    }
                }
            }
            .fullScreenCover(isPresented: $isServerPresented, content: {
                sharing.share(folder: .fileToShare)
            })
            .fullScreenCover(isPresented: $isConnectPresented, content: {
                sharing.recieve(delegate: DemoSharingFolderDelegate())
            })
           
            .preferredColorScheme(.dark)
               

        }
    }
}
