//
//  DownloadService.swift
//  HalfTunes
//
//  Created by Zehra on 18.10.2022.
//

import Foundation

class DownloadService {
    
    var downloadsSession: URLSession!
    var activeDownloads: [URL:Download] = [:]
    
    func startDownload(_ track: Track) {
        var download = Download(track: track)
        download.task = downloadsSession.downloadTask(with: track.previewURL)
        download.task?.resume()
        download.isDownloading = true
        activeDownloads[track.previewURL] = download
    }
    
    func pauseDownload(_ track: Track) {
        guard var download = activeDownloads[track.previewURL], download.isDownloading else { return }
        download.task?.cancel(byProducingResumeData: { data in
            download.resumeData = data
        })
        download.isDownloading = false
    }
    
    func resumeDownload(_ track: Track) {
        guard var download = activeDownloads[track.previewURL] else { return }
        if let resumeData = download.resumeData {
            download.task = downloadsSession.downloadTask(withResumeData: resumeData)
        } else {
            download.task = downloadsSession.downloadTask(with: download.track.previewURL)
        }
        
        download.task?.resume()
        download.isDownloading = true
        
    }
    
    func cancelDownload(_ track: Track) {
        guard let download = activeDownloads[track.previewURL] else { return }
        download.task?.cancel()
        activeDownloads[track.previewURL] = nil
    }
}
