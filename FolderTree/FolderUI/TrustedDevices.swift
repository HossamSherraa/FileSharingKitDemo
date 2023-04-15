//
//  TrustedDevices.swift
//  FileSharingKitDemoo
//
//  Created by macbook air on 11/04/2023.
//

import SwiftUI
import FileSharingKit
class TrustedDevicesViewModel<Delegate: SharingFolderDelegate>: ObservableObject {
    internal init(delegate: Delegate) {
        self.delegate = delegate
    }
    
    let delegate: Delegate
    
    @Published var trustedDevices : [TrustedDevice] = []
    func fetchTrustedDevices(){
        Task{
            let devices =  try await TrustedDevice.trustedDevices()
            await MainActor.run(body: {
                self.trustedDevices = devices
            })
        }
    }
}
struct TrustedDevices<Delegate : SharingFolderDelegate>: View {
    @StateObject var viewModel : TrustedDevicesViewModel<Delegate>
    init(delegate: Delegate) {
        self._viewModel = .init(wrappedValue: TrustedDevicesViewModel<Delegate>.init(delegate: delegate))
    }
    var body: some View {
        LazyVGrid(columns: [.init(.adaptive(minimum: 120), spacing: 10)]) {
            ForEach(viewModel.trustedDevices) { device in
                TrustedDeviceCell(trustedDevice: device, delegate: viewModel.delegate)
                     
            }
        }
    }
}

