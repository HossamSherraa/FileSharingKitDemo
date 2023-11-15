//
//  ItemView.swift
//  FilesharingLocalServer
//
//  Created by macbook air on 19/03/2023.
//

import SwiftUI
import QuickLook

struct ItemView<ItemMenu : ActionMenuView , VM : FolderViewModelProtocol>: View  where ItemMenu.Element == Folder{
    let item : Folder
    let itemMenu : ItemMenu
    
    @State var previewImage : UIImage?
    
    @State var filePreview: URL?
    
  
    
    @StateObject var viewModel : VM
    
    
    var body: some View {
      
        VStack{
            
            ZStack{
                if let previewImage {
                    RoundedRectangle(cornerRadius: 15, style: .continuous )
                        .frame(width: 100, height: 100)
                        .foregroundColor(.clear)
                        .overlay {
                            Image(uiImage: previewImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .clipShape( RoundedRectangle(cornerRadius: 15, style: .continuous ))
                        
                    
                        
                        
                }
            } .onTapGesture {
                Task{
                    let filePreview = try await viewModel.download(item: item, downloadLocation: .temporaryDirectory, progress: {progress in
                        
                    })
                    await MainActor.run {
                        self.filePreview = filePreview
                    }
                }
            }
                 
               
                
            Text(item.name)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            Group{
//                Text(item.creationDate , style: .date)
//                Text(item.fileExtension)
                
            }
                .font(.caption)
                .foregroundColor(.secondary)
            
           
            itemMenu.menu(for: item)
           
           

        }
       
        
        .quickLookPreview($filePreview)
       
        .task {
            let previewImage = await viewModel.getPreviewImageFor(item: item)
            await MainActor.run {
                self.previewImage = previewImage
            }
        }
       .onAppear {
            filePreview = nil 
        }
        
            
            
        
    }
}

 
