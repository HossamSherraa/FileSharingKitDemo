//
//  ServerRecieverView.swift
//  FilesharingLocalServer
//
//  Created by macbook air on 20/03/2023.
//

import SwiftUI
import FileSharingKit


class LocalFolderViewModel : FolderViewModelProtocol {
    func download(folder: Folder, downloadLocation: URL, progress: @escaping @Sendable (Double) -> Void) async throws {
        
    }
    
    
    func download(item: Folder, downloadLocation: URL, progress: @Sendable (Double) -> Void) async throws -> URL {
        item.originalURL
    }
    
    func upload(item: Folder, saveLocation: URL, progress: @Sendable (Double) -> Void) async throws {
         
    }
    
    
    
    @Published var folder  : Folder? = .myLocalFolder
    
     
    func getPreviewImageFor(item : Folder) async -> UIImage?{
        try? await ThumpnailProvider().getThumpnail(url: item.originalURL, size: .init(width: 90, height: 120))
    }
    func send(serverEvent : ServerFolderEvent<Folder>)async {
    }
}


struct LocalFolderView : View {
    @StateObject var viewModel : LocalFolderViewModel = .init()
    var body: some View {
       
        FolderView(itemMenu: EmptyItemViewActionsMenu(), folderMenu: EmptyFolderViewActionsMenu(), folder: .myLocalFolder , viewModel: viewModel)
        
    }
}

 

