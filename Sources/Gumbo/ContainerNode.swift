import Foundation
import CGumbo

public class ContainerNode: Node {
    
    
    override init(gumboNode: GumboNode, parent: Node? = nil, indexWithinParent: Int? = nil) {
        self.children = [Node]()
        super.init(gumboNode: gumboNode, parent: parent, indexWithinParent: indexWithinParent)
        
        let childrenVector: GumboVector?
        
        // Assign childrenVector depending on node type
        switch Kind(gumboType: gumboNode.type) {
        case .document: // Document node
            childrenVector = gumboNode.v.document.children
        case .element, .template: // Element node
            childrenVector = gumboNode.v.element.children
        default: // Text nodes have no children
            childrenVector = nil
        }
        
        
        
        if let childrenVector = childrenVector {
            for index in 0..<Int(childrenVector.length) {
                guard let child = childrenVector.data[index] else { continue }
                let childNodePtr = child.bindMemory(to: GumboNode.self, capacity: 1)
                let childNode = childNodePtr.pointee
                
                switch Node.Kind(gumboType: childNode.type) {
                case .document: // Document node
                    children.append(Document(gumboNode: childNode,
                                             parent: self,
                                             indexWithinParent: childNode.index_within_parent))
                case .element, .template: // Element node
                    children.append(Element(gumboNode: childNode,
                                            parent: self,
                                            indexWithinParent: childNode.index_within_parent))
                    
                default: // Text node
                    children.append(TextNode(gumboNode: childNode,
                                             parent: self,
                                             indexWithinParent: childNode.index_within_parent))
                }
                
            }
        }
        
        
    }
    

    
    /// Children
    private(set) public var children: [Node]
    
    public func elements(withTag tag: String) -> [Element] {
        
        var elements = [Element]()
        
        for child in children {
            if let element = child as? Element {
                
                if element.tag == tag.lowercased() {
                    elements.append(element)
                }
                
                elements.append(contentsOf: element.elements(withTag: tag))
                
            }
        }
        
        return elements
    }
    
    public func element(withId id: String) -> Element? {
        if let e = children.compactMap({ $0 as? Element }).first(where: { $0.attributes["id"] == id }) {
            return e
        } else {
            let containerChildren = children.compactMap({ $0 as? ContainerNode })
            for containerChild in containerChildren {
                if let e = containerChild.element(withId: id) {
                    return e
                }
            }
            return nil
        }
    }
    
    public func recursiveChildren(where predicate: ((Node)->Bool)) -> [Node] {
        var matched = children.filter(predicate)
        let childMatches = children.compactMap({ $0 as? ContainerNode }).map({ $0.recursiveChildren(where: predicate) }).flatMap({ $0 })
        matched.append(contentsOf: childMatches)
        return matched
    }
    
    public func allURLs(relativeTo webpageURL: URL?) -> Set<URL> {
        var allURLs = Set<URL>()
        for aElement in self.elements(withTag: "a") {
            guard let baseLink = aElement.attributes["href"] else { continue }
            guard let url = URL(string: baseLink, relativeTo: webpageURL) else { continue }
            guard let urlScheme = url.scheme, urlScheme == "http" || urlScheme == "https" else { continue }
            allURLs.insert(url)
        }
        return allURLs
    }
    
}
