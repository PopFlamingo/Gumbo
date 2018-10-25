import CGumbo
import Foundation

public class Element: ContainerNode {
    
    public var attributes: [String:String]
    public var tag: String
    
    override init(gumboNode: GumboNode, parent: Node? = nil, indexWithinParent: Int? = nil) {
        
        // Store attributes
        let rawAttributes = gumboNode.v.element.attributes
        var attributes = [String:String]()
        for attributeIndex in 0..<Int(rawAttributes.length) {
            let rawAttribute = rawAttributes.data[attributeIndex]!.bindMemory(to: GumboAttribute.self, capacity: 1).pointee
            let attributeName = String(cString: rawAttribute.name).lowercased()
            let attributeValue = String(cString: rawAttribute.value).lowercased()
            attributes[attributeName] = attributeValue
        }
        self.attributes = attributes
        
        // Tag
        tag = String(cString: gumbo_normalized_tagname(gumboNode.v.element.tag))
        
        
        super.init(gumboNode: gumboNode, parent: parent, indexWithinParent: indexWithinParent)
    }
}
