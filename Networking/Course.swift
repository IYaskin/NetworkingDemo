//
//  Course.swift
//  Networking
//
//  Created by Igor Yaskin on 14/10/2019.
//  Copyright © 2019 Alexey Efimov. All rights reserved.
//

import Foundation

struct Course: Decodable {
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
}
