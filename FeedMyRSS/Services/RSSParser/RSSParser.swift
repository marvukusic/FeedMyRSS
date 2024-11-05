//
//  RSSParser.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 05.11.2024.
//

import Foundation

class RSSParser: NSObject {
    private enum RssKeys: String {
        case title, description, url, item, link
        case media = "media:thumbnail"
    }
    
    private enum RssAttributes: String {
        case url
    }
    
    typealias RSSFeedResult = Result<RSSFeed, RSSParserError>
    
    private var feed = RSSFeed()
    private var currentItem: RSSItem?
    private var currentElement = ""
    private var currentText = ""
    
    private var completion: ((RSSFeedResult) -> Void)?
    
    func parse(data: Data, completion: @escaping (RSSFeedResult) -> Void) {
        self.completion = completion
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
}

extension RSSParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        currentText = ""
        
        switch RssKeys(rawValue: elementName) {
        case .item:
            currentItem = RSSItem()
            
        case .media:
            guard currentItem?.imageURL == nil else { break }
            currentItem?.imageURL = URL(string: attributeDict[RssAttributes.url.rawValue] ?? "")
            
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
        switch RssKeys(rawValue: elementName) {
        case .title:
            guard currentItem != nil else {
                feed.title = currentText
                return
            }
            currentItem?.title = currentText
            
        case .description:
            guard currentItem != nil else {
                feed.description = currentText
                return
            }
            currentItem?.description = currentText
            
        case .url:
            feed.imageURL = URL(string: currentText)
            
        case .link:
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
        completion?(.success(feed))
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        completion?(.failure(.errorParsingXML))
    }
    
    private func trimmed(_ string: String) -> String {
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
