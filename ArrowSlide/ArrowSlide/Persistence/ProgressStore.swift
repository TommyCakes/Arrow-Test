import Foundation

final class ProgressStore: ObservableObject {

    private let defaults = UserDefaults.standard
    private let bestMovesKey = "bestMoves"
    private let completedKey  = "completed"

    @Published private(set) var completed: Set<Int> = []
    @Published private(set) var bestMoves: [Int: Int] = [:]  // levelId → best move count

    static let shared = ProgressStore()

    private init() {
        if let raw = defaults.dictionary(forKey: bestMovesKey) as? [String: Int] {
            bestMoves = Dictionary(uniqueKeysWithValues: raw.compactMap { k, v in
                Int(k).map { ($0, v) }
            })
        }
        if let raw = defaults.array(forKey: completedKey) as? [Int] {
            completed = Set(raw)
        }
    }

    func record(levelId: Int, moves: Int) {
        completed.insert(levelId)
        if let current = bestMoves[levelId] {
            bestMoves[levelId] = min(current, moves)
        } else {
            bestMoves[levelId] = moves
        }
        persist()
    }

    func isUnlocked(_ level: Level) -> Bool {
        level.id == 1 || completed.contains(level.id - 1)
    }

    private func persist() {
        let raw = Dictionary(uniqueKeysWithValues: bestMoves.map { ("\($0.key)", $0.value) })
        defaults.set(raw, forKey: bestMovesKey)
        defaults.set(Array(completed), forKey: completedKey)
    }
}
