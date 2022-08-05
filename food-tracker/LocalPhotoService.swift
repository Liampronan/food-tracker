import Foundation
import Photos

struct LocalPhotoService {
    enum LocalPhotoServiceError: Error {
        case noImageFound
        case malformatedImageData
    }
    
    typealias FetchLatestPhotosCompletionHandler = (Result<Data, LocalPhotoServiceError>) -> Void
    
    static func fetchLatestPhotos(forCount count: Int?, completionHandler: @escaping FetchLatestPhotosCompletionHandler)  {

        // Create fetch options.
        let options = PHFetchOptions()

        // If count limit is specified.
        if let count = count { options.fetchLimit = count }

        // Add sortDescriptor so the lastest photos will be returned.
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortDescriptor]

        // Fetch the photos.
        let assets = PHAsset.fetchAssets(with: .image, options: options)
        
        // Note that if the request is not set to synchronous
        // the requestImageForAsset will return both the image
        // and thumbnail; by setting synchronous to true it
        // will return just the thumbnail
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true

        guard let firstImage = assets.firstObject else {
            completionHandler(.failure(.noImageFound))
            return
        }
        
        // Perform the image request
        PHImageManager.default().requestImageData(for: firstImage, options: requestOptions) { data, str, orientation, other in
            guard let data = data else {
                completionHandler(.failure(.malformatedImageData))
                return
            }
            
            completionHandler(.success(data))
        }
    }
}

