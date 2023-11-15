//
//  ItemViewActionsMenu.swift
//  FilesharingLocalServer
//
//  Created by macbook air on 22/03/2023.
//

import SwiftUI

struct ItemViewActionsMenu:ActionMenuView {

    let viewModel : SharedFolderViewModel
    
    func menu(for item : Folder)-> some View {
        InternalMenu(item: item, viewModel: viewModel)
    }
    
    
    
    struct InternalMenu : View {
        @State var isChossingFolderPresneted: Bool = false
        @State var isChossingFolderForUpload: Bool = false
        @State var isChossingFolderPresnetedForCopy: Bool = false
        @State var isChangeNamePresented: Bool = false
        let item : Folder
        @State var newName : String = ""
        let viewModel : SharedFolderViewModel
        
        @State var progress : Double?
        
        var body: some View {
            
            if let progress {
                ProgressView(value: progress , total: 1)
            }else {
                menu
            }
            
            
        }
        
        
        var menu : some View {
            Menu {
                Button {
                    
                    isChossingFolderPresnetedForCopy.toggle()
                } label: {
                    Label("Copy", systemImage: "doc.on.doc.fill" )
                }
                
                Button {
                    Task{
                        await viewModel.send(serverEvent: .deleteItem(item: item))
                    }
                } label: {
                    Label("Delete", systemImage: "trash.fill" )
                }
                
                Button {
                    self.isChossingFolderPresneted.toggle()
                } label: {
                    Label("Move", systemImage: "arrow.up.and.down.and.arrow.left.and.right" )
                }
                
                
                Button {
                    isChangeNamePresented.toggle()
                } label: {
                    Label("Rename", systemImage: "pencil" )
                }
                
               
                
                
                
            } label: {
                Image(systemName: "ellipsis.rectangle.fill")
                    .scaleEffect(1.4)
                    .sheet(isPresented: $isChossingFolderPresneted) {
                        SharedFolderSelection(serverViewModel: viewModel) { folder in
                            Task{
                                await viewModel.send(serverEvent: .moveItem(item: self.item, toFolder: folder))
                            }
                            isChossingFolderPresneted.toggle()
                            
                        }
                    }
                    .sheet(isPresented: $isChossingFolderPresnetedForCopy) {
                        MyFilesFolderSelection() { folder in
                            isChossingFolderPresnetedForCopy = false 
                            Task{
                                
                                let itemLocation = try await viewModel.download(item: item, downloadLocation: .temporaryDirectory ) {progress in
                                    self.progress = progress
                                }
                                progress = nil
                                try FileManager.default.copyItem(at: itemLocation, to: folder.originalLocation.appending(component: itemLocation.lastPathComponent))
                                
                            }
                            
                            
                            
                        } itemSelection: {_ in
                            
                        }
                    }
                   
                    .alert("Change name", isPresented: $isChangeNamePresented) {
                        
                        
                        TextField("Name", text: $newName)
                        Button("Change") {
                            Task{
                                await viewModel.send(serverEvent: .rename(item: item, name: newName))
                                await MainActor.run {
                                    self.newName = ""
                                }
                            }
                        }
                        Button("Cancel") {
                            
                            self.newName = ""
                            
                        }
                        
                    }
                
                
            }
        }
    }
}

struct EmptyItemViewActionsMenu:ActionMenuView {
    
    func menu(for item : Folder)-> some View{
        EmptyView()
    }
}

struct EmptyFolderViewActionsMenu:ActionMenuView {
    
    func menu(for item : Folder)-> some View{
        EmptyView()
    }
}


struct ItemViewSelectionMenu : ActionMenuView{
    let selection : (_ item : Folder)-> Void
    func menu(for item: Folder) -> some View {
        InternalMenu(item: item, selection: selection)
    }
    
    struct InternalMenu : View {
        let item : Folder
        let selection : (_ item : Folder)-> Void
        
        var body: some View {
            Button("Select") {
                selection(item)
            }
        }
        
    }
}
