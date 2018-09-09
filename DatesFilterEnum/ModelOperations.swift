//
//  ModelOperations.swift
//  DatesFilterEnum
//
//  Created by apple on 9/9/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation
struct Operations: Codable {
    let status: String
    let result: [model_operations]
}

struct model_operations: Codable {
    let date : String
    let notes : String
    let persons : String
    let userType : String
    let status : String
    let farmName : String
    let title : String
    let duration : String
    let operationName : String
    let createdDtm : String
  
}
