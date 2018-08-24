//
//  Repository.swift
//  Sample-iOS-with-Redux
//
//  Created by Minseok Choi on 24/08/2018.
//  Copyright © 2018 Minseok Choi. All rights reserved.
//

import Mapper

struct Repository: Mappable {
    let identifier: Int
    let language: String
    let name: String
    let fullName: String
    
    init(map: Mapper) throws {
        try identifier = map.from("id")
        try language = map.from("language")
        try name = map.from("name")
        try fullName = map.from("full_name")
    }
}
