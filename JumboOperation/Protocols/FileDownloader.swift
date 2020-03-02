//
//  FileDownloader.swift
//  JumboOperation
//
//  Created by zeus medina on 3/1/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation

/// Protocol for downloading a file
protocol FileDownloader {
    func downloadFile(from urlString: String, completionHandler: @escaping (Result<String, Error>) -> Void)
}
