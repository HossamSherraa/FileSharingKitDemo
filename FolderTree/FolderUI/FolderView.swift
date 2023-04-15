//
//  FolderView.swift
//  FilesharingLocalServer
//
//  Created by macbook air on 19/03/2023.
//

import SwiftUI
protocol ActionMenuView {
    associatedtype Element
    associatedtype Content : View
    func menu(for item : Element)-> Content
}

struct FolderView<ItemMenu : ActionMenuView , FolderMenu : ActionMenuView , VM : FolderViewModelProtocol> : View where ItemMenu.Element == Item , FolderMenu.Element  == Folder {
    let itemMenu : ItemMenu
    let folderMenu :  FolderMenu
    let folder : Folder
    
    @StateObject var viewModel : VM
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: [.init(.adaptive(minimum: 100, maximum: 130), alignment: .leading)] , alignment: .leading) {
                ForEach(folder.subFolders) { folder in
                    VStack{
                        NavigationLink {
                            FolderView(itemMenu: itemMenu, folderMenu: folderMenu, folder: folder, viewModel: viewModel)
                                
                        } label: {
                            VStack{
                                Image(systemName: "folder.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(.blue)
                                Group{
                                    Text(folder.name)
                                        .foregroundColor(.primary)
                                        .fontWeight(.medium)
                                    Text(folder.creationDate , style: .date)
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }
                            }
                        }
                        
                        folderMenu.menu(for: folder)
                    }
                }
                
                
                ForEach(folder.contents) { item in
                    ItemView(item: item, itemMenu: self.itemMenu , viewModel  : viewModel)
                         
                }
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal)
             
            .navigationTitle(folder.name)
        }

    }
    
}


 
