//
//  FolderViewModelProtocol.swift
//  FilesharingLocalServer
//
//  Created by Hossam on 08/04/2023.
//

import SwiftUI
import FileSharingKit
public protocol FolderViewModelProtocol : ObservableObject {
    var folder : Folder? {get set}
    func send(serverEvent : ServerFolderEvent<Folder>)async
    func download(item : Folder , downloadLocation : URL , progress : @Sendable @escaping (Double)->Void )async throws->URL
    func download(folder : Folder , downloadLocation : URL , progress : @Sendable @escaping (Double)->Void  )async throws 
    func getPreviewImageFor(item : Folder) async -> UIImage?
    func upload(item: Folder, saveLocation: URL , progress : @Sendable (Double)->Void) async throws
    
}
