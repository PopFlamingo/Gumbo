import Foundation
import CGumbo

public class Node {
    
    init(gumboNode: GumboNode, parent: Node? = nil, indexWithinParent: Int? = nil) {
        self.gumboNode = gumboNode
        self.kind = Kind(gumboType: gumboNode.type)
        self.parent = parent
        self.indexWithinParent = indexWithinParent
    }
    
    private var gumboNode: GumboNode
    
    public internal(set) weak var parent: Node?
    
    public var parentElement: Element? {
        return parent as? Element
    }
    
    public let kind: Kind
    
    /// The index of node within its parent
    public let indexWithinParent: Int?
    
    public enum Kind {
        
        init(gumboType: GumboNodeType) {
            switch gumboType {
            case GUMBO_NODE_DOCUMENT:
                self = .document
            case GUMBO_NODE_ELEMENT:
                self = .element
            case GUMBO_NODE_TEXT:
                self = .text
            case GUMBO_NODE_CDATA:
                self = .cdata
            case GUMBO_NODE_COMMENT:
                self = .comment
            case GUMBO_NODE_WHITESPACE:
                self = .whitespace
            case GUMBO_NODE_TEMPLATE:
                self = .template
            default:
                fatalError("Unknown document type")
            }
        }
        
        var gumboType: GumboNodeType {
            get {
                switch self {
                case .document:
                    return GUMBO_NODE_DOCUMENT
                case .element:
                    return GUMBO_NODE_ELEMENT
                case .text:
                    return GUMBO_NODE_TEXT
                case .cdata:
                    return GUMBO_NODE_CDATA
                case .comment:
                    return GUMBO_NODE_COMMENT
                case .whitespace:
                    return GUMBO_NODE_WHITESPACE
                case .template:
                    return GUMBO_NODE_TEMPLATE
                }
            }
        }
        
        case document
        case element
        case text
        case cdata
        case comment
        case whitespace
        case template
    }
    
    
    
}
