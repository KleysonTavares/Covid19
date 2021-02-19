//
//  Endpoints.swift
//  Covid19
//
//  Created by Kleyson on 16/02/2021.
//  Copyright © 2021 Kleyson Tavares. All rights reserved.
//

import Foundation

struct Endpoints {
    private static let baseUrl = "https://api.covid19api.com"
    static let cases = "\(baseUrl)/total/dayone/country/brazil"
}
