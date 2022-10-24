//
//  Download.swift
//  HalfTunes
//
//  Created by Zehra on 19.10.2022.
//

import Foundation

struct Download {
    var track: Track
    var isDownloading = false
    var progress: Float = 0
    var resumeData: Data?
    var task: URLSessionDownloadTask?
}
