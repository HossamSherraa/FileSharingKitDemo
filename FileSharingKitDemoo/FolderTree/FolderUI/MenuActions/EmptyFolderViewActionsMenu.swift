//
//  FolderViewActionsMenu.swift
//  FilesharingLocalServer
//
//  Created by macbook air on 22/03/2023.
//

import SwiftUI

struct EmptyFolderViewActionsMenu: ActionMenuView {
    typealias Element = Folder

    func menu(for item: Folder) -> some View {
        EmptyView()
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



 
