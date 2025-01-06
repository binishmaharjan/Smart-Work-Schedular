import Foundation

enum IconPreset: String, CaseIterable, Identifiable {
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
    
    var id: String { rawValue }
}
