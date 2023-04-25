//
//  FilesharingLocalServerApp.swift
//  FilesharingLocalServer
//
//  Created by macbook air on 18/03/2023.
//

import SwiftUI
import FileSharingKit
 
@main
struct FilesharingLocalServerApp: App {
    
    
    
    var body: some Scene {
        WindowGroup {
            
          MainSwiftUIView()
        }
    }
    
}


 
struct MainSwiftUIView: View , SharingFolderDelegate{
    @State var isConnectPresented : Bool = false
    @State var isServerPresented : Bool = false
    
    @State var server : ServerReciever<Folder>? = nil
    let sharing = FileSharing()
    
    var body: some View {
     
            NavigationView {
                VStack{
                    Button("Connect") {
                        isConnectPresented.toggle()
                    }
                    
                    Button("Server") {
                        isServerPresented.toggle()
                    }
                    
                    TrustedDevices(delegate: self)
                }
            }
            .fullScreenCover(isPresented: $isServerPresented, content: {
                sharing.share(folder: Folder.fileToShare , delegate: DefaultServerDelegate())
                    .environment(\.layoutDirection, .rightToLeft)
                    .environment(\.locale, .init(identifier: "ar"))
            })
            .fullScreenCover(isPresented: $isConnectPresented, content: {
                sharing.recieve(folderType: Folder.self ,delegate: self)
                    .environment(\.layoutDirection, .rightToLeft)
                    .environment(\.locale, .init(identifier: "ar"))
                   
            })
            .onAppear(perform: {
                try? FileManager.default.createDirectory(at: .documentsDirectory.appending(path: "/Main"), withIntermediateDirectories: true)
            })
           
            .preferredColorScheme(.dark)
            .fullScreenCover(item: $server) { server in
                SharedFolderView(server: server)
                    .task {
                        try? await server.startListenToStatus {
                            
                        } onDisconnect: {
                            self.server = nil
                        }

                    }
                     
            }
            
            
               

        
    }
    func presentSharedFolderView(server: FileSharingKit.ServerReciever<Folder>) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true)
        self.server = server
        }
    }
    
    func dismissSharedFolderView() {
        server = nil
    }
    func failToJoinServer() {
         print("FAIL TO JOIN")
    }
    
    func viewControllerForPresentingPasscode() -> UIViewController {
        UIApplication.shared.keyWindow!.rootViewController!
    }
}








class MainViewController : UIViewController , ServerDelegate , SharingFolderDelegate {
    
    
    
    typealias Event = ServerFolderEvent<Folder>
    
    typealias F = Folder
    
    
    
    
    let sharing = FileSharing()
    
    lazy var connectButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Connect To Server", for: .normal)
        
        button.addTarget(self, action: #selector(onPressConnect), for: .touchUpInside)
        return button
    }()
    
    lazy var serverButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Server", for: .normal)
        button.addTarget(self, action: #selector(onPressServer), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        let stack = UIStackView(arrangedSubviews: [connectButton , serverButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 30
        self.view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        ])
        
        
        
    }
    
    var keepME : UIViewController?
    @objc
    func onPressConnect(){
        let connectVC = sharing.recieveVM(folderType: Folder.self, delegate: self)
        connectVC.overrideUserInterfaceStyle = .dark
        self.keepME = connectVC
        
         present(connectVC, animated: true)
    }
    
    @objc
    func onPressServer(){
        let serverVC = sharing.shareVM(folder: Folder.fileToShare, delegate: self)
        serverVC.overrideUserInterfaceStyle = .dark
        serverVC.modalPresentationStyle = .fullScreen
        present(serverVC, animated: true)
    }
    
    
    
    //MARK: Connect to Server Delegate
    
    func viewControllerForPresentingPasscode() -> UIViewController {
        self
    }
    
    func dismissSharedFolderView() {
         self.dismiss(animated: true)
    }
    
    func failToJoinServer() {
        print("present Error")
    }
    
  
    func presentSharedFolderView(server: FileSharingKit.ServerReciever<Folder>) {
        dismiss(animated: true)
        let recievedFolderShareVC = UIHostingController(rootView: SharedFolderView(server: server))
        self.present(recievedFolderShareVC, animated: true)
    }
    
    
    
    //MARK: Server Delegate when you are the server
    
    func handel(event: ServerFolderEvent<Folder>) async throws {
        try await event.handle()
    }
}
