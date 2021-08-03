//
//  MarvelInfo.swift
//  Marvelgram
//
//  Created by Иван Карамазов on 02.08.2021.
//

import Foundation


struct MarvelInfo: Codable {
    var id: Int
    var name: String
    var description: String
    var modified: String
    var thumbnail: Thumbnail
}


struct Thumbnail: Codable {
    var path: String
    var `extension` : String
}
