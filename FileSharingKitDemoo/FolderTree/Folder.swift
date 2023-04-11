//
//  Folder.swift
//  FilesharingLocalServer
//
//  Created by macbook air on 19/03/2023.
//

import Foundation
import FileSharingKit

struct Folder: Identifiable , Hashable , Sharable {
    typealias Event = ServerFolderEvent<Folder>
    typealias Itemi = Item
    
    var originalURL: URL {
        originalLocation
    }
    
    let id : Int
    var creationDate : Date
    let name : String
    let originalLocation : URL
    var subFolders : [Folder] = []
    var contents : [Item] = []
    
    init(at location : URL) throws {
        let filemanager : FileManager = .default
        let attributes = try filemanager.attributesOfItem(atPath:location.path)
        self.creationDate = attributes[.creationDate] as! Date
        self.name = location.lastPathComponent
        self.id = (attributes[.systemFileNumber] as! NSNumber).intValue
        self.originalLocation = location
        try configFileContent(at: location)
    }
    
    
    private mutating func configFileContent(at location : URL) throws{
        let filemanager : FileManager = .default
        let enumaration = filemanager.enumerator(at: location, includingPropertiesForKeys: [], options: [.skipsSubdirectoryDescendants , .skipsHiddenFiles])!
        
        for url in enumaration {
            let url = url as! URL
            
            if try FileWrapper(url: url).isDirectory {
                
                let folder = try Folder(at: url)
                self.subFolders.append(folder)
            }else {
                
                let item = try Item(location: url)
                self.contents.append(item)
            }
            
        }
    }
    
    
    var items : [Item]{
        let contentEndpoints : [Item] = self.contents
        let subfoldersEndpoints : [Item] = self.subFolders.flatMap(\.items)
        return contentEndpoints + subfoldersEndpoints
    }
    
    
    func encode()throws->Data {
        try JSONEncoder().encode(self)
    }
    
    
    static func decode(from data : Data)throws-> Folder{
        try JSONDecoder().decode(Self.self, from: data)
    }
    
    
    static var fileToShare : Folder = try! Folder.init(at: URL.init(filePath: "/Users/macbookair/Downloads/Rt"))
    static var myLocalFolder : Folder {
        try! Folder.init(at: .init(filePath: "/Users/macbookair/Downloads/MyFolder"))
    }
    
    func rebuild() -> Folder {
        return try! .init(at: originalLocation)
    }
    
}


