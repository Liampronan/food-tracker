import Vision
import UIKit

struct ImageClassification {
    let identifier: String
    let confidence: Float
    
    init(from observation: VNClassificationObservation) {
        identifier = observation.identifier
        confidence = observation.confidence
    }
}

struct ImageClassifierService {
    enum ImageClassifierError: Error {
        case noCIImage
        case noObservations
    }
    
    static func classify(image: UIImage, maxResults: Int = 5) -> Result<[ImageClassification], ImageClassifierError> {
        guard let ciImage = CIImage(image: image) else {
            return .failure(.noCIImage)
        }
        let handler = VNImageRequestHandler(ciImage: ciImage)
        let request = VNClassifyImageRequest()
        try? handler.perform([request])
        guard let observerations = request.results else {
            return .failure(.noObservations)
        }

        let results = observerations.map { obs in
            return ImageClassification(from: obs)
        }.prefix(maxResults)
        
        //need to create Array here bc results is array slice 
        return .success(Array(results))
    }
    
    
}
