//
//  TrustedDevices.swift
//  FileSharingKitDemoo
//
//  Created by macbook air on 11/04/2023.
//

import SwiftUI

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
