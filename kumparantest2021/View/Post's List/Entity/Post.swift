//
//  Post.swift
//  kumparantest2021
//
//  Created by Ivan Martin on 19/07/2021.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
