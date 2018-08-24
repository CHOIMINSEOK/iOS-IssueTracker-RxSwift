//
//  Issue.swift
//  Sample-iOS-with-Redux
//
//  Created by Minseok Choi on 24/08/2018.
//  Copyright © 2018 Minseok Choi. All rights reserved.
//

import Mapper

struct Issue: Mappable {
    let identifier: Int
    let number: Int
    let title: String
    let body: String
    
    init(map: Mapper) throws {
        try identifier = map.from("id")
        try number = map.from("number")
        try title = map.from("title")
        try body = map.from("body")
    }
    
}
