//
//  Track.swift
//  HalfTunes
//
//  Created by Zehra on 17.10.2022.
//

import Foundation

struct Track {
    let id: Int
    let name: String
    let artist: String
    let previewURL: URL
    var downloaded = false
}
