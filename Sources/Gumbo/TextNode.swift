import Foundation
import CGumbo

public class TextNode: Node {
    
    var node: GumboNode
    public var text: String
    
    override init(gumboNode: GumboNode, parent: Node? = nil, indexWithinParent: Int? = nil) {
        self.node = gumboNode
        self.text = String(cString: node.v.text.text)
        super.init(gumboNode: gumboNode, parent: parent, indexWithinParent: indexWithinParent)
    }
}
