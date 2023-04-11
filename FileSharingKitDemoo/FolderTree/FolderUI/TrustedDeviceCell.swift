//
//  TrustedDevices.swift
//  FileSharingKitDemoo
//
//  Created by macbook air on 11/04/2023.
//

import SwiftUI

struct TrustedDeviceCell: View {
    var body: some View {
        VStack(spacing:10){
           
            
            Image(systemName: "iphone.gen2")
                .font(.system(size: 50))
            
           
                Text("iPhone Xs Max")
                    
                     
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.green)
            
            
        }
    }
}

struct TrustedDeviceCell_Previews: PreviewProvider {
    static var previews: some View {
        TrustedDeviceCell()
    }
}
