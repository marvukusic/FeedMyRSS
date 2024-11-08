//
//  RSSParser.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 05.11.2024.
//

import Foundation

class RSSParser: NSObject {
    private enum RSSKeys: String {
        case title, description, url, item, link
        case media = "media:thumbnail"
    }
    
    private enum RSSAttributes: String {
        case url
    }
    
    typealias RSSFeedResult = Result<RSSFeedContent, RSSParserError>
    
    private var feed = RSSFeedContent()
    private var currentItem: RSSItem?
    private var currentElement = ""
    private var currentText = ""
    private var skipItems = false
    
    private var completion: ((RSSFeedResult) -> Void)?
    
    func parseRSS(data: Data, skipItems: Bool = false, completion: @escaping (RSSFeedResult) -> Void) {
        self.skipItems = skipItems
        self.completion = completion
        
        resetInstanceProperties()
        
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parseRSS(data: Data, skipItems: Bool = false) async throws -> RSSFeedContent {
        try await withCheckedThrowingContinuation { continuation in
            parseRSS(data: data, skipItems: skipItems) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func resetInstanceProperties() {
        feed = RSSFeedContent()
        currentItem = nil
        currentElement = ""
        currentText = ""
    }
}

extension RSSParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        currentText = ""
        
        switch RSSKeys(rawValue: elementName) {
        case .item:
            currentItem = RSSItem()
            
        case .media:
            guard currentItem?.imageURL == nil else { break }
            currentItem?.imageURL = URL(string: attributeDict[RSSAttributes.url.rawValue] ?? "")
            
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard !trimmed(string).isEmpty else { return }
        currentText += trimmed(string)
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        currentText += trimmed(String(data: CDATABlock, encoding: .utf8) ?? "")
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch RSSKeys(rawValue: elementName) {
        case .title:
            guard currentItem != nil else {
                feed.title = !currentText.isEmpty ? currentText : nil
                return
            }
            currentItem?.title = currentText
            
        case .description:
            guard currentItem != nil else {
                feed.description = !currentText.isEmpty ? currentText : nil
                return
            }
            currentItem?.description = currentText
            
        case .url:
            feed.imageURL = URL(string: currentText)
            
        case .link:
            guard currentItem != nil else {
                feed.linkURL = URL(string: currentText)
                return
            }
            currentItem?.linkURL = URL(string: currentText)
            
        case .item:
            if let item = currentItem {
                feed.items.append(item)
            }
            currentItem = nil
            
        default:
            break
        }
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        if skipItems {
            feed.items = []
        }
        completion?(.success(feed))
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        completion?(.failure(.errorParsingXML))
    }
    
    private func trimmed(_ string: String) -> String {
        string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
