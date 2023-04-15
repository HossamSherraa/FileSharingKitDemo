//
//  TrustedDevices.swift
//  FileSharingKitDemoo
//
//  Created by macbook air on 11/04/2023.
//

import SwiftUI
import FileSharingKit
class TrustedDevicesViewModel : ObservableObject {
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
struct TrustedDevices: View {
    var body: some View {
        LazyVGrid(columns: [.init(.adaptive(minimum: 120), spacing: 10)]) {
            ForEach(0..<3) { _ in
                TrustedDeviceCell()
                     
            }
        }
    }
}

struct TrustedDevices_Previews: PreviewProvider {
    static var previews: some View {
        TrustedDevices()
    }
}
