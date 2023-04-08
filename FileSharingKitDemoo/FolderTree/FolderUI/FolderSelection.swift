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
    var selection : (_ selection : Folder ) -> Void
    var body: some View {
        NavigationStack {
            if let folder = localViewModel.folder {
                FolderView(itemMenu: EmptyItemViewActionsMenu(), folderMenu: FolderViewSelectionMenu(selection: selection), folder: folder, viewModel: localViewModel)
            }
            
        }
    }
}
