//
//  PhotoEditorView.swift
//  PhotoFilter
//
//  Created by Sheen on 10/22/24.
//

import SwiftUI

struct PhotoEditorView: View {
    @Environment(PhotoFilterInteractor.self) private var interactor
    private let cellSize: CGFloat = 70
    @Binding var selectedFilter: Filter?
    
    var body: some View {
        VStack {
            if let image = interactor.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
                    .transition(.scale.animation(.easeOut))
                HStack {
                    line
                    Text("Filters")
                    line
                }
                let filters = interactor.filters
                let filtersAndThumnails = interactor.filtersAndThumnails
                LazyVGrid(columns: [GridItem(.adaptive(minimum: cellSize, maximum: .infinity), spacing: 5)], spacing: 5) {
                    ForEach(filters, id: \.self) { filter in
                        let uiImage = filtersAndThumnails[filter]
                        let image = {
                            guard let uiImage else {
                                return Image(systemName: "photo")
                            }
                            return Image(uiImage: uiImage)
                        }()
                        PhotoFilterThumbnailView(filter: filter, selectedFilter: $selectedFilter, image: image)
                    }
                }
                .padding(.horizontal, 50.0)
                .padding(.vertical, 20.0)
            }
        }
    }
    
    var line: some View {
        VStack { Divider().background(Color.gray) }.padding(2.0)
    }
}

