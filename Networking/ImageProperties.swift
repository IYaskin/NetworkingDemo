//
//  ImageProperties.swift
//  Networking
//
//  Created by Igor Yaskin on 15/10/2019.
//  Copyright © 2019 Alexey Efimov. All rights reserved.
//

import UIKit

struct ImageProperties {
    
    let key: String
    let data: Data
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        guard let data = image.pngData() else { return nil }
        self.data = data
        print(self.data)
        print("!!!!!")
    }
}
