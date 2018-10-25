import Foundation
import CGumbo

public class TextNode: Node {
    
    var node: GumboNode
    public var text: String {
        return String(cString: node.v.text.text)
    }
    public var originalText: String {
        return String(cString: node.v.text.original_text.data)
    }
    
    override init(gumboNode: GumboNode, parent: Node? = nil, indexWithinParent: Int? = nil) {
        self.node = gumboNode
        super.init(gumboNode: gumboNode, parent: parent, indexWithinParent: indexWithinParent)
    }
}
