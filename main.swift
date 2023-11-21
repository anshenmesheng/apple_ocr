//
//  main.swift
//  OCR
//
//  Created by zen on 2023/11/21.
//

import Foundation
import Vision

guard CommandLine.arguments.count == 2 else {
    print("Usage: \(CommandLine.arguments[0]) <file_path>")
    exit(1)
}

let filePath = CommandLine.arguments[1]

if !FileManager.default.fileExists(atPath: filePath) {
    print("Invalid file path: \(filePath)")
    exit(1)
}

//let path = "/Users/zen/test/py-test/ocr/test1.jpg"
//let path = "/Users/zen/test/py-test/ocr/test1_crop_1.jpg"
let path = filePath

let imageURL = URL(fileURLWithPath: path)
do {
    let imageData = try Data(contentsOf: imageURL)
    guard let cgImage = CGImage(jpegDataProviderSource: CGDataProvider(data: imageData as CFData)!, decode: nil, shouldInterpolate: true, intent: .defaultIntent) else {
        fatalError("Unable to create CGImage from the provided data.")
    }
    
    let requestHandler = VNImageRequestHandler(cgImage: cgImage)
    
    let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
    request.recognitionLanguages = ["zh-Hans", "en-US"]
    
    try requestHandler.perform([request])
} catch {
    print("Unable to perform the requests: \(error).")
}


func recognizeTextHandler(request: VNRequest, error: Error?) {
    // handle the result or error from text recognition
    guard let observations = request.results as? [VNRecognizedTextObservation] else {
        return
    }
    
    let recognizedStrings = observations.compactMap { observation in
        return observation.topCandidates(1).first?.string
    }
    
    for s in recognizedStrings {
        print(s)
    }
}
