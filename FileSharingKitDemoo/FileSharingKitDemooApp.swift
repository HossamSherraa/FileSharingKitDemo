//
//  FilesharingLocalServerApp.swift
//  FilesharingLocalServer
//
//  Created by macbook air on 18/03/2023.
//

import SwiftUI
import FileSharingKit
@main
struct FilesharingLocalServerApp: App , SharingFolderDelegate {
    @State var isConnectPresented : Bool = false
    @State var isServerPresented : Bool = false
    
    @State var server : ServerReciever<Folder>? = nil
    let sharing = FileSharing()
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
                sharing.share(folder: Folder.fileToShare , delegate: DefaultServerDelegate())
                
            })
            .fullScreenCover(isPresented: $isConnectPresented, content: {
                sharing.recieve(folderType: Folder.self ,delegate: self)
                    .sheet(item: $server) { server in
                        SharedFolderView(server: server)
                    }
            })
            .onAppear(perform: {
                try? FileManager.default.createDirectory(at: .documentsDirectory.appending(path: "/Main"), withIntermediateDirectories: true)
            })
           
            .preferredColorScheme(.dark)
            
               

        }
    }
    func presentSharedFolderView(server: FileSharingKit.ServerReciever<Folder>) {
        self.server = server
    }
    
    func dismissSharedFolderView() {
        server = nil
    }
    
    
}

