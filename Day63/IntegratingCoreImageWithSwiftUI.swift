//
//  IntegratingCoreImageWithSwiftUI.swift
//  100DaysOfSwiftUI
//
//  Created by 褚宣德 on 2023/10/31.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fit)
        }
        .onAppear(perform: loadImage)
   
    }
    func loadImage() {
        guard let inputImage = UIImage(named: "Example") else { return }
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        // 可變更濾鏡效果
        let currentFilter = CIFilter.sepiaTone()
        currentFilter.inputImage = beginImage
        
        let amount = 1.0
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey)
        }

        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
        }
    }
   
}


#Preview {
    ContentView()
}
