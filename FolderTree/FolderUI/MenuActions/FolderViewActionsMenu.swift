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
        @State var progress : Double?
        
        @State var isChossingFolderForUpload : Bool = false
        @State var isChossingFolderForDownload : Bool = false
        
        
    var body: some View {
        VStack{
            if let progress {
                ProgressView(value: progress , total: 1)
            }else {
                Menu {
                    Button {
                        isChossingFolderForUpload.toggle()
                    } label: {
                        Label("Put File", systemImage: "paperplane.fill" )
                    }
                    
                    Button {
                        isChossingFolderForDownload.toggle()
                    } label: {
                        Label("Download Folder", systemImage: "paperplane.fill" )
                    }
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                }
            }
            
        }
        .sheet(isPresented: $isChossingFolderForUpload) {
            MyFilesFolderSelection() { folder in
                
               
              
                
                
            } itemSelection: { item in
                isChossingFolderForUpload = false
                Task{
                    
                    do {
                        print("Start Uplaoding")
                        try await viewModel.upload(item:item, saveLocation: self.folder.originalURL.appending(component: item.originalURL.lastPathComponent), progress: { progress in 
                            self.progress = progress
                        })
                        
                        progress = nil
                        
                        print("End Uplaoding")
                       
                    } catch {
                        print("Error Uplaoding \(error)")
                    }
                    
                }
            }
        }
        
        
        .sheet(isPresented: $isChossingFolderForDownload) {
            MyFilesFolderSelection(folderSelection: { selection in
                Task{
                    try await viewModel.download(folder: self.folder, downloadLocation: selection.originalLocation, progress: { progress in
                        self.progress = progress
                        print(self.progress , "PROGGGGKKKFFI3232")
                        
                        
                    })
                    
                    progress = nil
                }
            }, itemSelection: {_ in })
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



 
