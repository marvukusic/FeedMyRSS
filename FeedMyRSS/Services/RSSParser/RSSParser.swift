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
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
    }
}
