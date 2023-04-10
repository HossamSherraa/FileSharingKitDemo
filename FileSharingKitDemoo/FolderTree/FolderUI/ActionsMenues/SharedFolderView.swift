//
//  SharedFolderView.swift
//  FilesharingLocalServer
//
//  Created by Hossam on 08/04/2023.
//

import Foundation
import FileSharingKit
import SwiftUI

class SharedFolderViewModel : FolderViewModelProtocol {
    func upload(item: some SharableItem, saveLocation: URL) async throws {
        try await server.upload(item: item, saveLocation: saveLocation)
    }
    
    internal init(server: ServerReciever<Folder>) {
        self.server = server
    }
    
    @Published var folder  : Folder?
    
    
    
    private let server : ServerReciever<Folder>
    
    
    func onGetFolder(){
        
        Task{
            let folder = try await self.server.getFolder()
            await MainActor.run {
                self.folder = folder
            }
            
        }
    }
    
    func download(item : Item , downloadLocation : URL = .temporaryDirectory)async throws->URL {
        
        try await server.download(item: item , downloadLocation: downloadLocation)
        
    }
    
    func getPreviewImageFor(item : Item) async -> UIImage?{
        try? await  server.previewFor(item: item)
    }
    func send(serverEvent : ServerFolderEvent<Folder>)async {
        let newFolder =  try? await server.send(serverEvent: serverEvent)
        await MainActor.run {
            self.folder = newFolder
            
        }
    }
    
    
    
}





 

struct SharedFolderView : View {
    @StateObject var viewModel : SharedFolderViewModel
    @Environment(\.dismiss)
    var dismiss
    
    init(server : ServerReciever<Folder>){
        _viewModel = .init(wrappedValue: .init(server: server))
    }
    
    var body: some View {
        NavigationView {
            if let folder = viewModel.folder {
                FolderView(itemMenu: ItemViewActionsMenu(viewModel: viewModel), folderMenu: FolderViewActionsMenu(viewModel: viewModel), folder: folder , viewModel: viewModel )
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
                                dismiss()
                            }
                        }
                    }
            }
        }
        .onAppear(perform: viewModel.onGetFolder)
        
    }
}
