import SwiftUI

enum ArrowDirection: Int, Codable, CaseIterable {
    case up, right, down, left

    var angle: Double {
        switch self {
        case .up:    return 0
        case .right: return 90
        case .down:  return 180
        case .left:  return 270
        }
    }

    var vector: (row: Int, col: Int) {
        switch self {
        case .up:    return (-1, 0)
        case .right: return (0, 1)
        case .down:  return (1, 0)
        case .left:  return (0, -1)
        }
    }
}

enum ArrowColor: Int, Codable, CaseIterable {
    case red, orange, yellow, green, blue, purple

    var color: Color {
        switch self {
        case .red:    return Color(red: 0.92, green: 0.26, blue: 0.26)
        case .orange: return Color(red: 0.96, green: 0.55, blue: 0.13)
        case .yellow: return Color(red: 0.95, green: 0.85, blue: 0.10)
        case .green:  return Color(red: 0.22, green: 0.76, blue: 0.42)
        case .blue:   return Color(red: 0.22, green: 0.53, blue: 0.95)
        case .purple: return Color(red: 0.65, green: 0.30, blue: 0.90)
        }
    }

    var darkColor: Color {
        switch self {
        case .red:    return Color(red: 0.70, green: 0.10, blue: 0.10)
        case .orange: return Color(red: 0.75, green: 0.35, blue: 0.00)
        case .yellow: return Color(red: 0.75, green: 0.65, blue: 0.00)
        case .green:  return Color(red: 0.08, green: 0.55, blue: 0.25)
        case .blue:   return Color(red: 0.08, green: 0.32, blue: 0.72)
        case .purple: return Color(red: 0.45, green: 0.12, blue: 0.68)
        }
    }
}

struct Arrow: Identifiable, Codable, Equatable {
    let id: UUID
    var row: Int
    var col: Int
    var direction: ArrowDirection
    var color: ArrowColor

    init(id: UUID = UUID(), row: Int, col: Int, direction: ArrowDirection, color: ArrowColor) {
        self.id = id
        self.row = row
        self.col = col
        self.direction = direction
        self.color = color
    }
}
