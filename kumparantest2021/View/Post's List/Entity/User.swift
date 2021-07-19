//
//  User.swift
//  kumparantest2021
//
//  Created by Ivan Martin on 19/07/2021.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: UserAddress
    let phone: String
    let website: String
    let company: UserCompany
}

struct UserAddress: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: UserAddressGeo
}

struct UserAddressGeo: Codable {
    let lat: String
    let lng: String
}

struct UserCompany: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
}

/*
 {
     "id": 1,
     "name": "Leanne Graham",
     "username": "Bret",
     "email": "Sincere@april.biz",
     "address": {
       "street": "Kulas Light",
       "suite": "Apt. 556",
       "city": "Gwenborough",
       "zipcode": "92998-3874",
       "geo": {
         "lat": "-37.3159",
         "lng": "81.1496"
       }
     },
     "phone": "1-770-736-8031 x56442",
     "website": "hildegard.org",
     "company": {
       "name": "Romaguera-Crona",
       "catchPhrase": "Multi-layered client-server neural-net",
       "bs": "harness real-time e-markets"
     }
   }
 */
