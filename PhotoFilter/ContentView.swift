//
//  ContentView.swift
//  PhotoFilter
//
//  Created by Sheen on 10/27/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @Environment(PhotoFilterInteractor.self) private var interactor
    @State private var photosPickerItem : PhotosPickerItem?
    @State private var selectedFilter: Filter?
    @State private var image: Image?
    
    var body: some View {
        NavigationStack {
            VStack {
                if interactor.image != nil {
                    PhotoEditorView(selectedFilter: $selectedFilter)
                } else {
                    PhotosPicker(selection: $photosPickerItem) {
                        Text("Add an Image")
                    }
                }
            }
            .toolbar {
                if selectedFilter != nil {
                    Button("Reset Filter") {
                        selectedFilter = nil
                        interactor.resetFilter()
                    }
                }
                PhotosPicker(selection: $photosPickerItem) {
                    Text("Add an Image")
                }
            }
            .onChange(of: photosPickerItem) {
                Task {
                    if let selectedImageData = try? await photosPickerItem?.loadTransferable(type: Data.self) {
                        selectedFilter = nil
                        interactor.loadImageData(data: selectedImageData)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
