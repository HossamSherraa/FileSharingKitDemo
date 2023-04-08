//
//  ThumpnailView.swift
//  FilesharingLocalServer
//
//  Created by macbook air on 19/03/2023.
//

import SwiftUI
import CoreDataLightKit

import QuickLookThumbnailing
import FileSharingKit


struct ThumpnailView: View {
      init(url: URL, size: CGSize  ) {
        self.url = url
        self.size = size
    }
    
    
    
    let url : URL
    @State private var result : UIImage?
    private var size : CGSize
    var body: some View {
        Rectangle()
            .foregroundColor(.white)
             
            .overlay(content: {
                if let result {
                    Image(uiImage: result)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                      
                         
                }
            })
            .clipped()
             
            .task {
               let result =  try? await ThumpnailProvider().getThumpnail(url: url, size: size)
                await MainActor.run {
                    self.result = result
                }
            }
            
    }
}


 

