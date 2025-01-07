import Foundation

public enum IconPreset {
    public enum Image: String, CaseIterable, Identifiable {
        case abc = "abc"
        case sunMax = "sun.max.fill"
        case sunHaze = "sun.haze.fill"
        case moon = "moon.fill"
        case home = "house.fill"
        case dollarSign = "dollarsign.circle.fill"
        case desktop = "desktopcomputer"
        case envelope = "envelope.fill"
        
        case airplane = "airplane"
        case car = "car.fill"
        
        case cart = "cart.fill"
        case fork = "fork.knife"
        case cup = "cup.and.saucer.fill"
        case birthday = "birthday.cake.fill"
        case book = "book.fill"
        case dumbbell = "dumbbell.fill"
        case video = "video.fill"
        case controller = "gamecontroller.fill"
        
        case cross = "cross.case.fill"
        case pill = "pill.fill"
        case heart = "heart.fill"
        
        public var id: String { rawValue }
    }
    
    public enum Color: String, CaseIterable, Identifiable {
        case red = "FF3B30"
        case blue = "33ADE5"
        case green = "33BF59"
        case orange = "FF9400"
        case yellow = "FFCC00"
        case purple = "B251DE"
        case custom = "000000"
        
        public var id: String { rawValue }
    }
}
