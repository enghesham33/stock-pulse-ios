//
//  APIErrorDTO.swift
//  StockPulse
//
//  Created by Hesham Khaled on 26/03/2026.
//

import Foundation

struct APIErrorDTO: Decodable {
    let code: String?
    let description: String?
}
