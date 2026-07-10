import Foundation
import Combine

enum SlideAxis {
    case row(Int)   // slide all arrows in this row
    case col(Int)   // slide all arrows in this col
}

final class GameEngine: ObservableObject {

    // MARK: - Published state

    @Published private(set) var arrows: [Arrow] = []
    @Published private(set) var moves: Int = 0
    @Published private(set) var isSolved: Bool = false
    @Published private(set) var level: Level

    // MARK: - History for undo

    private var history: [[Arrow]] = []

    // MARK: - Init

    init(level: Level) {
        self.level = level
        self.arrows = level.initialArrows
    }

    // MARK: - Slide

    /// Slide an entire row or column by `delta` steps (+1 or -1).
    /// Arrows wrap around (toroidal) so nothing falls off.
    func slide(axis: SlideAxis, delta: Int) {
        guard delta != 0 && !isSolved else { return }
        history.append(arrows)

        switch axis {
        case .row(let r):
            arrows = arrows.map { arrow in
                guard arrow.row == r else { return arrow }
                var a = arrow
                a.col = wrap(a.col + delta, size: level.gridSize)
                return a
            }
        case .col(let c):
            arrows = arrows.map { arrow in
                guard arrow.col == c else { return arrow }
                var a = arrow
                a.row = wrap(a.row + delta, size: level.gridSize)
                return a
            }
        }

        moves += 1
        checkSolved()
    }

    // MARK: - Undo

    func undo() {
        guard let prev = history.popLast() else { return }
        arrows = prev
        moves = max(0, moves - 1)
        isSolved = false
    }

    // MARK: - Reset

    func reset() {
        history = []
        arrows = level.initialArrows
        moves = 0
        isSolved = false
    }

    // MARK: - Private helpers

    private func wrap(_ value: Int, size: Int) -> Int {
        ((value % size) + size) % size
    }

    private func checkSolved() {
        let targets = level.targetArrows
        for target in targets {
            let match = arrows.first {
                $0.row == target.row &&
                $0.col == target.col &&
                $0.direction == target.direction &&
                $0.color == target.color
            }
            if match == nil { return }
        }
        isSolved = true
    }
}
