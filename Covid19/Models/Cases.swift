//
//  Cases.swift
//  Covid19
//
//  Created by Kleyson on 16/02/2021.
//  Copyright © 2021 Kleyson Tavares. All rights reserved.
//

import Foundation

struct Case: Codable  {
    let Country: String
    let Confirmed: Int
    let Deaths: Int
    let Recovered:Int
    let Active: Int
    let Date: String
}
