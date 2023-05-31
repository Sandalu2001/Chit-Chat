import Foundation

struct K {
    static let appName = "⚡️Chit Chat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let pink = "Pink"
        static let cream = "Cream"
        static let backgroundColor = "Background"
        static let blackPink = "BlackPink"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}

