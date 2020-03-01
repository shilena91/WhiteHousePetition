//
//  Petition.swift
//  WhiteHousePetitions
//
//  Created by Hoang Pham on 1.3.2020.
//  Copyright © 2020 Hoang Pham. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
