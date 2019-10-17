//
//  WebsiteDescription.swift
//  Networking
//
//  Created by Igor Yaskin on 14/10/2019.
//  Copyright © 2019 Alexey Efimov. All rights reserved.
//

import Foundation

struct WebsiteDescription: Decodable {
    
    let websiteDescription: String?
    let websiteName: String?
    let courses: [Course]
}
