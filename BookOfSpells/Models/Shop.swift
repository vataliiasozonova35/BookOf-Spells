import Foundation

class Shop {
    
    private let playerKey = "playerKey"
    private let portalKey = "portalKey"
    private let coinsKey = "coinsKey"
    
    var balls = [
        "book1",
        "book2",
        "book3",
        "book4"
    ]
    
    var portals = [
        "cauldron",
        "coffer",
        "cup",
        "magicBall"
    ]

    
    var ballSkins = [Skin]()
    var portalSkins = [Skin]()
    
    static let shared = Shop()
    
    var ball: Int {
        get {
            return UserDefaults.standard.integer(forKey: playerKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: playerKey)
        }
    }
    
    var portal: Int {
        get {
            return UserDefaults.standard.integer(forKey: portalKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: portalKey)
        }
    }
    
    var coins: Int {
        get {
            return UserDefaults.standard.integer(forKey: coinsKey)
        }
        set {
            guard newValue > 0 else { return }
            UserDefaults.standard.set(newValue, forKey: coinsKey)
        }
    }
    
    func isBoughtBall(at pos: Int) -> Bool {
        return UserDefaults.standard.bool(forKey: "book\(pos)")
    }
    
    func buyBall(at pos: Int) {
        UserDefaults.standard.set(true, forKey: "book\(pos)")
    }
    
    func isBoughtPortal(at pos: Int) -> Bool {
        return UserDefaults.standard.bool(forKey: "\(portals[pos])")
    }
    
    func buyPortal(at pos: Int) {
        UserDefaults.standard.set(true, forKey: "\(portals[pos])")
    }
    
    
    init() {
        UserDefaults.standard.register(defaults: [
            playerKey : 0,
            coinsKey : 0,
            portalKey: 0
        ])
        
        var index = 0
        for ball in balls {
            if index == 0 {
                UserDefaults.standard.register(defaults: [ball:true])
                ballSkins.append(.init(price: 0, position: index, name: ball))
            } else {
                UserDefaults.standard.register(defaults: [ball:false])
                ballSkins.append(.init(price: 200 + index * 50, position: index, name: ball))
            }
            index += 1
        }
        
        index = 0
        for portal in portals {
            if index == 0 {
                print("asd")
                print(portal)
                portalSkins.append(.init(price: 0, position: index, name: portal))
                UserDefaults.standard.register(defaults: [portal:true])
            } else {
                portalSkins.append(.init(price: 200 + index * 50, position: index, name: portal))
                UserDefaults.standard.register(defaults: [portal:false])
            }
            index += 1
        }
    }
}

struct Skin: Hashable {
    var price: Int
    var position: Int
    var name: String
}
