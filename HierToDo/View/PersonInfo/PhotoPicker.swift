//
//  PhotoPicker.swift
//  HierToDo
//
//  Created by Xu (Jordan) Han on 2024/4/13.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: View {
    @Environment(ModelData.self) var modelData
    
    @Binding var uiImage: UIImage
        
    @State private var showPhotoPicker: Bool = false
    @State private var selectedItem: PhotosPickerItem?
    
    @State private var showCameraPicker: Bool = false
    
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""

    var body: some View {
        Menu {
            Section {
                Button(action: {
                    showCameraPicker = true
                }) {
                    Label("Camera", systemImage: "camera")
                }
                
                Button(action: {
                    showPhotoPicker = true
                }) {
                    Label("Photo", systemImage: "photo.on.rectangle.angled")
                }
            }
            
        } label: {
            Image(uiImage: uiImage)
                .resizable()
                .frame(width: 200, height: 150)
                .clipShape(Circle())                .overlay {
                    Rectangle()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.secondary)
                        .offset(y: 100)
                }
                .overlay{
                    Image(systemName: "photo.badge.plus")
                        .foregroundStyle(.white)
                        .offset(y:62)
                }
                .clipShape(Circle())
        }
        .menuStyle(.button)
        .fullScreenCover(isPresented: $showCameraPicker) {
            CameraControllerView() { uiImage in
                self.uiImage = uiImage // force to rerender all views depende on this state
                if !modelData.updatePhoto(uiImage: uiImage) {
                    showAlert = true
                    alertTitle = "Error"
                    alertMessage = "Failed to update photo"
                }
                if !modelData.save() {
                    showAlert = true
                    alertTitle = "Error"
                    alertMessage = "Failed to save"
                }
            }
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) {
            DispatchQueue.main.async {
                selectedItem?.loadTransferable(type: Image.self) { result in
                    switch result {
                    case .success(let img?):
                        DispatchQueue.main.async {
                            let imageRenderer = ImageRenderer(content: img)
                            if let uiImage = imageRenderer.uiImage {
                                self.uiImage = uiImage // force to rerender all views depende on this state
                                if !modelData.updatePhoto(uiImage: uiImage) {
                                    showAlert = true
                                    alertTitle = "Error"
                                    alertMessage = "Failed to update photo"
                                }
                                if !modelData.save() {
                                    showAlert = true
                                    alertTitle = "Error"
                                    alertMessage = "Failed to save"
                                }
                            }
                        }
                    case _:
                        showAlert = true
                        alertTitle = "Error"
                        alertMessage = "Failed to select image"
                    }
                }
            }
        }
        .alert(alertTitle, isPresented: $showAlert) {
               Button("OK", role: .cancel) {}
           } message: { Text(alertMessage) }
        
    }
}

#Preview {
    PhotoPicker(uiImage: .constant(UIImage(named: "Jared")!))
        .environment(ModelData())
}
