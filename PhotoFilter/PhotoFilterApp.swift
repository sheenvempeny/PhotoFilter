//
//  PhotoFilterApp.swift
//  PhotoFilter
//
//  Created by Sheen on 10/27/24.
//

import SwiftUI

@main
struct PhotoFilterApp: App {
    
    @State var interactor = PhotoFilterInteractor()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(interactor)
    }
}
