//
//  SharedFolderSelection.swift
//  FilesharingLocalServer
//
//  Created by Hossam on 22/03/2023.
//

import SwiftUI


struct SharedFolderSelection: View {
    @StateObject var serverViewModel : SharedFolderViewModel
    var selection : (_ selection : Folder ) -> Void
    
    var body: some View {
        NavigationStack {
            if let folder = serverViewModel.folder {
                FolderView(itemMenu: EmptyItemViewActionsMenu(), folderMenu: FolderViewSelectionMenu(selection: selection), folder: folder, viewModel: serverViewModel)
            }
        }
    }
}


struct MyFilesFolderSelection : View {
    @StateObject var localViewModel : LocalFolderViewModel = .init()
    var folderSelection : (_ selection : Folder ) -> Void
    var itemSelection : (_ itemSelection : Folder ) -> Void
    var body: some View {
        NavigationStack {
            if let folder = localViewModel.folder {
                FolderView(itemMenu: ItemViewSelectionMenu(selection: itemSelection), folderMenu: FolderViewSelectionMenu(selection: folderSelection), folder: folder, viewModel: localViewModel)
            }
            
        }
    }
}
