//
//  FolderServerEvent.swift
//  FilesharingLocalServer
//
//  Created by Hossam on 08/04/2023.
//

import FileSharingKit
import Foundation
enum ServerFolderEvent<F:Sharable> :  SharableFolderEvent{
    case deleteFolder(folder :F )
    case deleteItem(item : F.Itemi)
    case moveFolder(folder : F , toFolder : F)
    case moveItem(item : F.Itemi , toFolder : F)
    case rename(item : F.Itemi , name : String)
    
    
    func handle()async throws{
        switch self {
        case .deleteFolder(let folder):
            try deleteFile(at: folder.originalURL)
        case .deleteItem(let item):
            try deleteFile(at: item.originalURL)
        case .moveFolder(let folder, let toFolder):
            try moveFile(at: folder.originalURL, to: toFolder.originalURL)
        case .moveItem(let item, let toFolder):
            try moveFile(at: item.originalURL, to: toFolder.originalURL)
        case .rename(item: let item , name : let name) :
            try rename(item: item, name: name)
            
        }
    }
    
    private func deleteFile(at location : URL) throws {
        try FileManager.default.removeItem(at: location)
    }
    
    private func moveFile(at location : URL , to newLocation : URL) throws {
        try FileManager.default.moveItem(at: location, to: newLocation.appending(path: location.lastPathComponent))
    }
    
    
    private func rename(item : some SharableItem , name : String)throws{
        let type = item.originalURL.pathExtension
        var newLocation = item.originalURL.deletingLastPathComponent()
 
        newLocation.append(component: "\(name).\(type)")
        
        try FileManager.default.moveItem(at: item.originalURL, to: newLocation)
       
    }
    
}


