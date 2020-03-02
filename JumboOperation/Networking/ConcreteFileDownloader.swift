//
//  ConcreteFileDownloader.swift
//  JumboOperation
//
//  Created by zeus medina on 3/1/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation

/// A concrete implementation of FileDownloader
class ConcreteFileDownloader: FileDownloader {
    enum NetworkError: Error {
        case badURL
    }
    
    /**
     Function that downloads a file and converts into a string
     - parameter urlString: Describe the alpha param
     - parameter completionHandler: Accepts a completion handler... when invoked either returns a string representation of the file or an error
    */
    func downloadFile(from urlString: String, completionHandler: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(NetworkError.badURL))
            return
        }
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }
                guard let localURL = localURL, let jsFile = try? String(contentsOf: localURL) else {
                    completionHandler(.failure(NetworkError.badURL))
                    return
                }

                completionHandler(.success(jsFile))
            }
        }
        task.resume()
    }
    
    
}
