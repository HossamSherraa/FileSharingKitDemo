//
//  FolderViewActionsMenu.swift
//  FilesharingLocalServer
//
//  Created by macbook air on 22/03/2023.
//

import SwiftUI

struct FolderViewActionsMenu: ActionMenuView {
    typealias Element = Folder

    let viewModel : SharedFolderViewModel
    func menu(for item: Folder) -> some View {
        InnerMenu(folder : item , viewModel : viewModel)

    }
    
    
    struct InnerMenu : View {
        let folder : Folder
        let viewModel : SharedFolderViewModel
        
        @State var isChossingFolderForUpload : Bool = false
        
    var body: some View {
        Menu {
            Button {
                isChossingFolderForUpload.toggle()
            } label: {
                Label("Put File", systemImage: "paperplane.fill" )
            }
        } label: {
                Image(systemName: "ellipsis.circle.fill")
        }
        .sheet(isPresented: $isChossingFolderForUpload) {
            MyFilesFolderSelection() { folder in
                
               
              
                
                
            } itemSelection: { item in
                Task{
                    do {
                        print("Start Uplaoding")
                        try await viewModel.upload(item:item, saveLocation: self.folder.originalURL.appending(component: item.originalURL.lastPathComponent))
                        
                        print("End Uplaoding")
                       
                    } catch {
                        print("Error Uplaoding \(error)")
                    }
                    
                }
            }
        }
        
       
    }
    }
}


struct FolderViewSelectionMenu: ActionMenuView {
    typealias Element = Folder
    var selection : (_ folder : Folder)-> Void
   
    
    func menu(for item: Folder) -> some View {
       SelectButton(folder: item, selection: selection)
    }
    
    struct SelectButton : View {
        @Environment(\.dismiss) var dismiss
        let folder : Folder
        var selection : (_ folder : Folder)-> Void
        
        var body: some View {
            Button("Select") {
                dismiss()
                selection(folder)
            }
            .buttonStyle(.bordered)
        }
    }
}



 
