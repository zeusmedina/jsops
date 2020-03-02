//
//  FileDownloaderMocks.swift
//  JumboOperationTests
//
//  Created by zeus medina on 3/1/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation
@testable import JumboOperation

internal class MockSuccessFileDownloader: FileDownloader {
    func downloadFile(from urlString: String, completionHandler: @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.main.async {
            completionHandler(.success("javascript"))
        }
    }
}

internal class MockErrorFileDownloader: FileDownloader {
    func downloadFile(from urlString: String, completionHandler: @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.main.async {
            completionHandler(.failure(ConcreteFileDownloader.NetworkError.badURL))
        }
    }
}
