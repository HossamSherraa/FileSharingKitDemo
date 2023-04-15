//
//  Item.swift
//  FilesharingLocalServer
//
//  Created by macbook air on 18/03/2023.
//

import Foundation
import UniformTypeIdentifiers
import FileSharingKit
struct Item: Identifiable  , Hashable , SharableItem{
     
    
    let id : Int
    let creationDate : Date
    let name : String
    let fileExtension : String
    let type : UTType?
  
    let originalURL : URL

    
    init(location : URL)throws{
        let filemanager : FileManager = .default
        let attributes = try filemanager.attributesOfItem(atPath:location.path)
        self.creationDate = attributes[.creationDate] as! Date
        self.name = location.lastPathComponent
        self.id = (attributes[.systemFileNumber] as! NSNumber).intValue
        self.fileExtension = location.pathExtension
        self.type = try? location.resourceValues(forKeys: [.contentTypeKey]).contentType
        self.originalURL = location
        
        
        
    }
    
    static let fakeItem : Item =  try! Item.init(location: URL(filePath: "/Users/macbookair/Downloads/Rt/2.png".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
}


 
