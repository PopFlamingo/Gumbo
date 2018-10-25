import Foundation
import CGumbo


public class Document: ContainerNode {
    
    
    override init(gumboNode: GumboNode, parent: Node? = nil, indexWithinParent: Int? = nil) {
        super.init(gumboNode: gumboNode, parent: parent, indexWithinParent: indexWithinParent)
    }
    
    public convenience init(string: String) {
        let outputPtr = gumbo_parse(string.cString(using: .utf8)!)!
        
        self.init(gumboNode: outputPtr.pointee.document.pointee,
                  parent: nil,
                  indexWithinParent: nil)
        
        var opts = kGumboDefaultOptions
        gumbo_destroy_output(&opts, outputPtr)
    }

    var url: URL?
    
    public convenience init(url: URL) throws {
        let string = try String(contentsOf: url)
        self.init(string: string)
        self.url = url
    }
    

}

