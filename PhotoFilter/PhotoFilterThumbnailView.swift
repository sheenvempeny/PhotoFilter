//
//  PhotoFilterThumbnailView.swift
//  PhotoFilter
//
//  Created by Sheen on 10/26/24.
//

import SwiftUI

struct PhotoFilterThumbnailView: View {
    @Environment(PhotoFilterInteractor.self) private var interactor
    var filter: Filter
    @Binding var selectedFilter: Filter?
    var image: Image
    
    var body: some View {
        Button(action: {
            selectedFilter = filter
            interactor.applyFilter(filter: filter)
        }) {
            VStack {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke((selectedFilter == filter) ? Color.blue : Color.clear, lineWidth: 2.0))
                    .shadow(radius: 10)
                
                Text(filter.displayName)
                    .font(.system(size: 12.0))
                    .shadow(color: Color.primary.opacity(0.3), radius: 3, x: 0, y: 2)
            }
        }
        .buttonStyle(.plain)
        .overlay(alignment: .topTrailing) {
            if filter == selectedFilter {
                Button(action: {
                    selectedFilter = nil
                    interactor.resetFilter()
                }) {
                    Image(systemName: "xmark.circle")
                        .renderingMode(.template)
                        .foregroundColor(.red)
                        .blendMode(.normal)
                        .shadow(color: .gray, radius: 20, x: 5.0, y: 5.0)
                        .imageScale(.large)
                }
                .buttonStyle(.plain)
                .offset(x: 9.0, y: -9.0)
            }
        }
    }
}
