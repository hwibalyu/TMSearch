//
//  Trademark.swift
//  TMSearch
//
//  Created by KeonWoo HAN on 2017. 3. 10..
//  Copyright © 2017년 FunDrinker. All rights reserved.
//

import SWXMLHash

struct Trademark: XMLIndexerDeserializable {
    
    let appNumber: String
    let regNumber: String
    let title: String
    let drawingUrl: String
    let thumbnailUrl: String
    let applicant: String
    let productCode: String
    let status: String
    
    static func deserialize(_ element: XMLIndexer) throws -> Trademark {
        return try Trademark(
            appNumber: element["ApplicationNumber"].value(),
            regNumber: element["RegistrationNumber"].value(),
            title: element["Title"].value(),
            drawingUrl: element["ImagePath"].value(),
            thumbnailUrl: element["ThumbnailPath"].value(),
            applicant: element["ApplicantName"].value(),
            productCode: element["GoodClassificationCode"].value(),
            status: element["ApplicationStatus"].value()
            
        )
    }

    
    
}
