//
//  SearchCompleterDelegate.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 02.05.2026.
//

import MapKit

final class SearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    
    var onResults: (([MKLocalSearchCompletion]) -> Void)?
    var onError: ((Error) -> Void)?
    
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        onResults?(completer.results)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
        onError?(error)
    }
}
