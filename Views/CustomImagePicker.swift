//
//  SwiftUIView.swift
//  
//
//  Created by Samuel Vulakh on 5/17/23.
//

import SwiftUI

public struct CustomImagePicker: UIViewControllerRepresentable {
    
    /// The User Image To Be Selected
    @Binding var image: UIImage?
    
    /// The User Source For Recieving The Image
    @Binding var type: UIImagePickerController.SourceType
    
    init(image: Binding<UIImage?>, type: Binding<UIImagePickerController.SourceType> = .constant(.photoLibrary)) {
        self._image = image
        self._type = type
    }
    
    public func makeCoordinator() -> ImagePickerCoordinator {
        ImagePickerCoordinator(image: $image)
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = context.coordinator
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return pickerController }
        
        pickerController.sourceType = type
        return pickerController
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    public final class ImagePickerCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        @Binding var image: UIImage?
        
        init(image: Binding<UIImage?>) {
            _image = image
        }
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            guard let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            
            self.image = uiImage
            picker.dismiss(animated: true, completion: nil)
        }
        
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print("Canceled")
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

public extension View {
    
    /// For Multiple Source Types
    func imagePicker(_ show: Binding<(Bool, UIImagePickerController.SourceType)>, image: Binding<UIImage?>) -> some View {
        sheet(isPresented: show.0) {
            CustomImagePicker(image: image, type: show.1)
        }
    }
    
    /// One Single Source Image Picker
    func imagePicker(
        _ show: Binding<Bool>,
        image: Binding<UIImage?>,
        source: UIImagePickerController.SourceType = .photoLibrary
    ) -> some View {
        sheet(isPresented: show) {
            CustomImagePicker(image: image, type: .constant(source))
        }
    }
    
    /// Photo Library Image Picker
    func photoLibrary(_ show: Binding<Bool>, image: Binding<UIImage?>) -> some View {
        sheet(isPresented: show) {
            CustomImagePicker(image: image)
        }
    }
}

@available(iOS 13.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
        }
        .imagePicker(.constant(true), image: .constant(nil))
    }
}
