//
//  FolderViewModelProtocol.swift
//  FilesharingLocalServer
//
//  Created by Hossam on 08/04/2023.
//

import SwiftUI
protocol FolderViewModelProtocol : ObservableObject {
    var folder : Folder? {get set}
    func send(serverEvent : ServerFolderEvent<Folder>)async
    func download(item : Item , downloadLocation : URL)async throws->URL
    func getPreviewImageFor(item : Item) async -> UIImage?
    
}
