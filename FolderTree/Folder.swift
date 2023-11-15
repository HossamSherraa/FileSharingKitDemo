//
//  Folder.swift
//  FilesharingLocalServer
//
//  Created by macbook air on 19/03/2023.
//

import Foundation
import FileSharingKit

public struct Folder: Identifiable , Hashable , Sharable {
    public typealias Event = ServerFolderEvent<Folder>
    
    
    public var originalURL: URL {
        originalLocation
    }
    
    public let id : Int
    var creationDate : Date
    let name : String
    let fileExtension : String
    let originalLocation : URL
    public var subFolders : [Folder] = []
    public var contents : [Folder] = []
    
    public init(at location : URL) throws {
        let filemanager : FileManager = .default
        let attributes = try filemanager.attributesOfItem(atPath:location.path)
        self.creationDate = attributes[.creationDate] as! Date
        self.name = location.lastPathComponent
        self.id = (attributes[.systemFileNumber] as! NSNumber).intValue
        self.fileExtension = ""
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
                
                let item = try Folder(at: url)
                self.contents.append(item)
            }
            
            
        }
    }
    
    
    var items : [Folder]{
        let contentEndpoints : [Folder] = self.contents
        let subfoldersEndpoints : [Folder] = self.subFolders
        return contentEndpoints + subfoldersEndpoints
    }
    
    
    func encode()throws->Data {
        try JSONEncoder().encode(self)
    }
    
    
    static func decode(from data : Data)throws-> Folder{
        try JSONDecoder().decode(Self.self, from: data)
    }
    
    
    public  static var fileToShare : Folder = try! Folder.init(at: URL.init(filePath: "/Users/hossam/Downloads/NewMusicCovers"))
    public static var myLocalFolder : Folder {
        try! Folder.init(at: URL.init(filePath: "/Users/hossam/Downloads/Okk"))
    }
    
    public func rebuild() -> Folder {
        return try! .init(at: originalLocation)
    }
    
   
    
}


