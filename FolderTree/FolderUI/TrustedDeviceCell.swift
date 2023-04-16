//
//  TrustedDevices.swift
//  FileSharingKitDemoo
//
//  Created by macbook air on 11/04/2023.
//

import SwiftUI
import FileSharingKit

class TrustedDeviceCellViewModel<Delegate : SharingFolderDelegate> : ObservableObject {
    let trustedDevice : TrustedDevice
    let delegate : Delegate
    
    var name : String {
        trustedDevice.deviceName
    }
    @MainActor
    @Published var isLoading : Bool = false
    init(trustedDevice: TrustedDevice , delegate : Delegate) {
        self.trustedDevice = trustedDevice
        self.delegate = delegate
    }
    
    func onPress(){
        Task{
            await MainActor.run {
                isLoading = true
            }
                
            try await TrustedDeviceJoiner(device: trustedDevice, delegate: delegate).join()
            await MainActor.run(body: {
                isLoading = false
            })
        }
    }
    
}
struct TrustedDeviceCell<Delegate : SharingFolderDelegate>: View {
    @StateObject var viewModel : TrustedDeviceCellViewModel<Delegate>
    init(trustedDevice : TrustedDevice , delegate : Delegate) {
        self._viewModel = .init(wrappedValue: TrustedDeviceCellViewModel<Delegate>.init(trustedDevice: trustedDevice, delegate: delegate))
    }
    var body: some View {
        VStack(spacing:10){
           
            
            Image(systemName: "iphone.gen2")
                .font(.system(size: 50))
            
           
            Text(viewModel.name)
                    
                     
               
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            
        }
        .onTapGesture {
            viewModel.onPress()
        }
    }
}

 
