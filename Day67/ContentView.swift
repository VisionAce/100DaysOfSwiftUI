//
//  ContentView.swift
//  Instafilter
//
//  Created by 褚宣德 on 2023/10/30.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 100.0
  
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context =  CIContext()
    
    @State private var showingFilterSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    
                    Text("Tap to select a picture")
                        .foregroundStyle(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity) {
                            applyProcessing()
                        }
                }
                .padding(.vertical)
                
                HStack {
                    Text("Radius")
                    Slider(value: $filterRadius, in: 1...1000)
                        .onChange(of: filterRadius) {
                            applyProcessing()
                        }
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter") {
                       showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save", action: save)
                        .disabled(image == nil)
                }
                
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .onChange(of: inputImage) { loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("CircularWrap") { setFilter(CIFilter.circularWrap()) }
                Button("Exposure Adjust") { setFilter(CIFilter.exposureAdjust()) }
                Button("Straighten") { setFilter(CIFilter.straighten()) }
                Button("DotScreen") { setFilter(CIFilter.dotScreen()) }
                Button("Color Invert") { setFilter(CIFilter.colorInvert()) }
                Button("Cancle", role: .cancel) { }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
        
    func save() {
        guard let processedImage = processedImage else { return }
        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            print("Success!")
        }
        
        imageSaver.errorHandler = {
            print("Oops! \($0.localizedDescription)")
        }
        
        imageSaver.writeToPhotoALbum(image: processedImage)
    }
    
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: 150, y: 150), forKey: kCIInputCenterKey)
        }
        
        if inputKeys.contains(kCIInputEVKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputEVKey)
        }
        
        if inputKeys.contains(kCIInputAngleKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputAngleKey)
        }
        
        if inputKeys.contains(kCIInputWidthKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputWidthKey)
        }
        
        if inputKeys.contains(kCIInputSharpnessKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputSharpnessKey)
        }
        
     
        
        
        guard let outputimage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputimage, from: outputimage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
 

   
}


#Preview {
    ContentView()
}
