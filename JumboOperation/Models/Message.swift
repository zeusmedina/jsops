//
//  Message.swift
//  JumboOperation
//
//  Created by zeus medina on 2/27/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation

struct Message: Decodable {
    enum State: String, Decodable {
        case started
        case error
        case success
    }
    
    enum MessageType: String, Decodable {
        case progress
        case completed
    }
    
    let id: String
    let message: MessageType
    let progress: Int?
    let state: State?
}
