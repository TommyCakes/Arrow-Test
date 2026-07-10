import Foundation

struct Level: Identifiable, Codable {
    let id: Int
    let title: String
    let gridSize: Int          // square grid, e.g. 5 means 5×5
    let initialArrows: [Arrow]
    let targetArrows: [Arrow]  // arrows that must match (position + direction + color)
    let parMoves: Int

    // A level is solved when every target arrow exists in the grid
    // at the correct (row, col) with correct direction and color.
}

// MARK: - Built-in puzzle pack

extension Level {

    static let all: [Level] = buildLevels()

    // swiftlint:disable function_body_length
    private static func buildLevels() -> [Level] {
        var levels: [Level] = []

        // ── TUTORIAL PACK (1–5) ─────────────────────────────────────────────

        // Level 1 – single row, slide one arrow right
        levels.append(Level(
            id: 1, title: "First Step", gridSize: 4,
            initialArrows: [
                Arrow(row: 1, col: 0, direction: .right, color: .blue),
                Arrow(row: 1, col: 1, direction: .right, color: .red),
            ],
            targetArrows: [
                Arrow(row: 1, col: 2, direction: .right, color: .blue),
                Arrow(row: 1, col: 3, direction: .right, color: .red),
            ],
            parMoves: 1
        ))

        // Level 2 – two rows, simple vertical slide
        levels.append(Level(
            id: 2, title: "Two Lanes", gridSize: 4,
            initialArrows: [
                Arrow(row: 0, col: 1, direction: .down, color: .green),
                Arrow(row: 1, col: 1, direction: .down, color: .orange),
            ],
            targetArrows: [
                Arrow(row: 2, col: 1, direction: .down, color: .green),
                Arrow(row: 3, col: 1, direction: .down, color: .orange),
            ],
            parMoves: 1
        ))

        // Level 3 – cross move: slide col then row
        levels.append(Level(
            id: 3, title: "The Turn", gridSize: 4,
            initialArrows: [
                Arrow(row: 0, col: 0, direction: .right, color: .purple),
                Arrow(row: 0, col: 1, direction: .down,  color: .red),
                Arrow(row: 1, col: 1, direction: .right, color: .blue),
            ],
            targetArrows: [
                Arrow(row: 0, col: 2, direction: .right, color: .purple),
                Arrow(row: 1, col: 1, direction: .down,  color: .red),
                Arrow(row: 1, col: 2, direction: .right, color: .blue),
            ],
            parMoves: 2
        ))

        // Level 4 – jam: need to move blocking arrow first
        levels.append(Level(
            id: 4, title: "The Block", gridSize: 4,
            initialArrows: [
                Arrow(row: 2, col: 0, direction: .right, color: .yellow),
                Arrow(row: 2, col: 1, direction: .right, color: .green),
                Arrow(row: 2, col: 2, direction: .right, color: .orange),
            ],
            targetArrows: [
                Arrow(row: 2, col: 1, direction: .right, color: .yellow),
                Arrow(row: 2, col: 2, direction: .right, color: .green),
                Arrow(row: 2, col: 3, direction: .right, color: .orange),
            ],
            parMoves: 3
        ))

        // Level 5 – bigger 5×5, two independent groups
        levels.append(Level(
            id: 5, title: "Two Groups", gridSize: 5,
            initialArrows: [
                Arrow(row: 0, col: 0, direction: .right, color: .blue),
                Arrow(row: 0, col: 1, direction: .right, color: .blue),
                Arrow(row: 4, col: 3, direction: .left,  color: .red),
                Arrow(row: 4, col: 4, direction: .left,  color: .red),
            ],
            targetArrows: [
                Arrow(row: 0, col: 3, direction: .right, color: .blue),
                Arrow(row: 0, col: 4, direction: .right, color: .blue),
                Arrow(row: 4, col: 0, direction: .left,  color: .red),
                Arrow(row: 4, col: 1, direction: .left,  color: .red),
            ],
            parMoves: 2
        ))

        // ── EASY PACK (6–15) ────────────────────────────────────────────────

        levels.append(Level(
            id: 6, title: "Corridor", gridSize: 5,
            initialArrows: [
                Arrow(row: 2, col: 0, direction: .right, color: .green),
                Arrow(row: 2, col: 1, direction: .right, color: .green),
                Arrow(row: 2, col: 2, direction: .right, color: .yellow),
            ],
            targetArrows: [
                Arrow(row: 2, col: 2, direction: .right, color: .green),
                Arrow(row: 2, col: 3, direction: .right, color: .green),
                Arrow(row: 2, col: 4, direction: .right, color: .yellow),
            ],
            parMoves: 2
        ))

        levels.append(Level(
            id: 7, title: "Cross Roads", gridSize: 5,
            initialArrows: [
                Arrow(row: 0, col: 2, direction: .down,  color: .orange),
                Arrow(row: 1, col: 2, direction: .down,  color: .purple),
                Arrow(row: 2, col: 0, direction: .right, color: .blue),
                Arrow(row: 2, col: 1, direction: .right, color: .red),
            ],
            targetArrows: [
                Arrow(row: 3, col: 2, direction: .down,  color: .orange),
                Arrow(row: 4, col: 2, direction: .down,  color: .purple),
                Arrow(row: 2, col: 3, direction: .right, color: .blue),
                Arrow(row: 2, col: 4, direction: .right, color: .red),
            ],
            parMoves: 2
        ))

        levels.append(Level(
            id: 8, title: "Four Corners", gridSize: 5,
            initialArrows: [
                Arrow(row: 0, col: 0, direction: .down,  color: .red),
                Arrow(row: 0, col: 4, direction: .left,  color: .blue),
                Arrow(row: 4, col: 0, direction: .right, color: .green),
                Arrow(row: 4, col: 4, direction: .up,    color: .yellow),
            ],
            targetArrows: [
                Arrow(row: 4, col: 0, direction: .down,  color: .red),
                Arrow(row: 0, col: 0, direction: .left,  color: .blue),
                Arrow(row: 4, col: 4, direction: .right, color: .green),
                Arrow(row: 0, col: 4, direction: .up,    color: .yellow),
            ],
            parMoves: 4
        ))

        levels.append(Level(
            id: 9, title: "Shuffle", gridSize: 5,
            initialArrows: [
                Arrow(row: 1, col: 0, direction: .right, color: .purple),
                Arrow(row: 1, col: 1, direction: .right, color: .orange),
                Arrow(row: 3, col: 3, direction: .left,  color: .purple),
                Arrow(row: 3, col: 4, direction: .left,  color: .orange),
            ],
            targetArrows: [
                Arrow(row: 1, col: 3, direction: .right, color: .purple),
                Arrow(row: 1, col: 4, direction: .right, color: .orange),
                Arrow(row: 3, col: 0, direction: .left,  color: .purple),
                Arrow(row: 3, col: 1, direction: .left,  color: .orange),
            ],
            parMoves: 2
        ))

        levels.append(Level(
            id: 10, title: "Bottleneck", gridSize: 5,
            initialArrows: [
                Arrow(row: 0, col: 2, direction: .down, color: .blue),
                Arrow(row: 1, col: 2, direction: .down, color: .red),
                Arrow(row: 2, col: 2, direction: .down, color: .green),
            ],
            targetArrows: [
                Arrow(row: 2, col: 2, direction: .down, color: .blue),
                Arrow(row: 3, col: 2, direction: .down, color: .red),
                Arrow(row: 4, col: 2, direction: .down, color: .green),
            ],
            parMoves: 2
        ))

        levels.append(Level(
            id: 11, title: "Zigzag", gridSize: 5,
            initialArrows: [
                Arrow(row: 0, col: 0, direction: .right, color: .yellow),
                Arrow(row: 2, col: 2, direction: .down,  color: .red),
                Arrow(row: 4, col: 1, direction: .right, color: .blue),
            ],
            targetArrows: [
                Arrow(row: 0, col: 4, direction: .right, color: .yellow),
                Arrow(row: 4, col: 2, direction: .down,  color: .red),
                Arrow(row: 4, col: 4, direction: .right, color: .blue),
            ],
            parMoves: 3
        ))

        levels.append(Level(
            id: 12, title: "Pincer", gridSize: 5,
            initialArrows: [
                Arrow(row: 2, col: 0, direction: .right, color: .orange),
                Arrow(row: 2, col: 4, direction: .left,  color: .purple),
                Arrow(row: 0, col: 2, direction: .down,  color: .green),
                Arrow(row: 4, col: 2, direction: .up,    color: .red),
            ],
            targetArrows: [
                Arrow(row: 2, col: 2, direction: .right, color: .orange),
                Arrow(row: 2, col: 3, direction: .left,  color: .purple),
                Arrow(row: 2, col: 2, direction: .down,  color: .green),
                Arrow(row: 3, col: 2, direction: .up,    color: .red),
            ],
            parMoves: 4
        ))

        levels.append(Level(
            id: 13, title: "Mirror", gridSize: 6,
            initialArrows: [
                Arrow(row: 1, col: 0, direction: .right, color: .blue),
                Arrow(row: 1, col: 1, direction: .right, color: .blue),
                Arrow(row: 4, col: 4, direction: .left,  color: .red),
                Arrow(row: 4, col: 5, direction: .left,  color: .red),
            ],
            targetArrows: [
                Arrow(row: 1, col: 4, direction: .right, color: .blue),
                Arrow(row: 1, col: 5, direction: .right, color: .blue),
                Arrow(row: 4, col: 0, direction: .left,  color: .red),
                Arrow(row: 4, col: 1, direction: .left,  color: .red),
            ],
            parMoves: 2
        ))

        levels.append(Level(
            id: 14, title: "Stack", gridSize: 6,
            initialArrows: [
                Arrow(row: 0, col: 0, direction: .down, color: .green),
                Arrow(row: 1, col: 0, direction: .down, color: .green),
                Arrow(row: 2, col: 0, direction: .down, color: .yellow),
                Arrow(row: 3, col: 0, direction: .down, color: .yellow),
            ],
            targetArrows: [
                Arrow(row: 2, col: 0, direction: .down, color: .green),
                Arrow(row: 3, col: 0, direction: .down, color: .green),
                Arrow(row: 4, col: 0, direction: .down, color: .yellow),
                Arrow(row: 5, col: 0, direction: .down, color: .yellow),
            ],
            parMoves: 2
        ))

        levels.append(Level(
            id: 15, title: "Relay", gridSize: 6,
            initialArrows: [
                Arrow(row: 0, col: 0, direction: .right, color: .orange),
                Arrow(row: 0, col: 1, direction: .right, color: .purple),
                Arrow(row: 5, col: 4, direction: .left,  color: .orange),
                Arrow(row: 5, col: 5, direction: .left,  color: .purple),
            ],
            targetArrows: [
                Arrow(row: 0, col: 4, direction: .right, color: .orange),
                Arrow(row: 0, col: 5, direction: .right, color: .purple),
                Arrow(row: 5, col: 0, direction: .left,  color: .orange),
                Arrow(row: 5, col: 1, direction: .left,  color: .purple),
            ],
            parMoves: 2
        ))

        // ── MEDIUM PACK (16–25) ──────────────────────────────────────────────

        levels.append(Level(
            id: 16, title: "Weave", gridSize: 6,
            initialArrows: [
                Arrow(row: 0, col: 0, direction: .right, color: .red),
                Arrow(row: 0, col: 1, direction: .right, color: .blue),
                Arrow(row: 3, col: 0, direction: .right, color: .green),
                Arrow(row: 3, col: 1, direction: .right, color: .yellow),
                Arrow(row: 5, col: 4, direction: .left,  color: .red),
                Arrow(row: 5, col: 5, direction: .left,  color: .green),
            ],
            targetArrows: [
                Arrow(row: 0, col: 4, direction: .right, color: .red),
                Arrow(row: 0, col: 5, direction: .right, color: .blue),
                Arrow(row: 3, col: 4, direction: .right, color: .green),
                Arrow(row: 3, col: 5, direction: .right, color: .yellow),
                Arrow(row: 5, col: 0, direction: .left,  color: .red),
                Arrow(row: 5, col: 1, direction: .left,  color: .green),
            ],
            parMoves: 4
        ))

        levels.append(Level(
            id: 17, title: "Orbit", gridSize: 6,
            initialArrows: [
                Arrow(row: 0, col: 0, direction: .right, color: .purple),
                Arrow(row: 0, col: 5, direction: .down,  color: .purple),
                Arrow(row: 5, col: 5, direction: .left,  color: .purple),
                Arrow(row: 5, col: 0, direction: .up,    color: .purple),
            ],
            targetArrows: [
                Arrow(row: 0, col: 1, direction: .right, color: .purple),
                Arrow(row: 1, col: 5, direction: .down,  color: .purple),
                Arrow(row: 5, col: 4, direction: .left,  color: .purple),
                Arrow(row: 4, col: 0, direction: .up,    color: .purple),
            ],
            parMoves: 4
        ))

        levels.append(Level(
            id: 18, title: "Conveyor", gridSize: 6,
            initialArrows: [
                Arrow(row: 2, col: 0, direction: .right, color: .orange),
                Arrow(row: 2, col: 1, direction: .right, color: .orange),
                Arrow(row: 2, col: 2, direction: .right, color: .blue),
                Arrow(row: 2, col: 3, direction: .right, color: .blue),
            ],
            targetArrows: [
                Arrow(row: 2, col: 2, direction: .right, color: .orange),
                Arrow(row: 2, col: 3, direction: .right, color: .orange),
                Arrow(row: 2, col: 4, direction: .right, color: .blue),
                Arrow(row: 2, col: 5, direction: .right, color: .blue),
            ],
            parMoves: 2
        ))

        levels.append(Level(
            id: 19, title: "Swap", gridSize: 6,
            initialArrows: [
                Arrow(row: 1, col: 0, direction: .right, color: .red),
                Arrow(row: 1, col: 5, direction: .left,  color: .blue),
                Arrow(row: 4, col: 0, direction: .right, color: .blue),
                Arrow(row: 4, col: 5, direction: .left,  color: .red),
            ],
            targetArrows: [
                Arrow(row: 1, col: 4, direction: .right, color: .red),
                Arrow(row: 1, col: 1, direction: .left,  color: .blue),
                Arrow(row: 4, col: 4, direction: .right, color: .blue),
                Arrow(row: 4, col: 1, direction: .left,  color: .red),
            ],
            parMoves: 4
        ))

        levels.append(Level(
            id: 20, title: "Spinner", gridSize: 6,
            initialArrows: [
                Arrow(row: 0, col: 2, direction: .down,  color: .green),
                Arrow(row: 2, col: 5, direction: .left,  color: .yellow),
                Arrow(row: 5, col: 3, direction: .up,    color: .orange),
                Arrow(row: 3, col: 0, direction: .right, color: .purple),
            ],
            targetArrows: [
                Arrow(row: 3, col: 2, direction: .down,  color: .green),
                Arrow(row: 2, col: 2, direction: .left,  color: .yellow),
                Arrow(row: 2, col: 3, direction: .up,    color: .orange),
                Arrow(row: 3, col: 3, direction: .right, color: .purple),
            ],
            parMoves: 5
        ))

        levels.append(Level(
            id: 21, title: "Pipeline", gridSize: 6,
            initialArrows: [
                Arrow(row: 0, col: 0, direction: .down,  color: .blue),
                Arrow(row: 1, col: 0, direction: .down,  color: .blue),
                Arrow(row: 2, col: 0, direction: .down,  color: .red),
                Arrow(row: 0, col: 5, direction: .down,  color: .red),
                Arrow(row: 1, col: 5, direction: .down,  color: .green),
                Arrow(row: 2, col: 5, direction: .down,  color: .green),
            ],
            targetArrows: [
                Arrow(row: 3, col: 0, direction: .down,  color: .blue),
                Arrow(row: 4, col: 0, direction: .down,  color: .blue),
                Arrow(row: 5, col: 0, direction: .down,  color: .red),
                Arrow(row: 3, col: 5, direction: .down,  color: .red),
                Arrow(row: 4, col: 5, direction: .down,  color: .green),
                Arrow(row: 5, col: 5, direction: .down,  color: .green),
            ],
            parMoves: 4
        ))

        levels.append(Level(
            id: 22, title: "Cascade", gridSize: 6,
            initialArrows: [
                Arrow(row: 0, col: 0, direction: .right, color: .purple),
                Arrow(row: 0, col: 1, direction: .right, color: .orange),
                Arrow(row: 1, col: 0, direction: .right, color: .red),
                Arrow(row: 1, col: 1, direction: .right, color: .yellow),
            ],
            targetArrows: [
                Arrow(row: 4, col: 4, direction: .right, color: .purple),
                Arrow(row: 4, col: 5, direction: .right, color: .orange),
                Arrow(row: 5, col: 4, direction: .right, color: .red),
                Arrow(row: 5, col: 5, direction: .right, color: .yellow),
            ],
            parMoves: 4
        ))

        levels.append(Level(
            id: 23, title: "Detour", gridSize: 6,
            initialArrows: [
                Arrow(row: 0, col: 0, direction: .right, color: .blue),
                Arrow(row: 0, col: 1, direction: .right, color: .blue),
                Arrow(row: 3, col: 3, direction: .up,    color: .red),
                Arrow(row: 4, col: 3, direction: .up,    color: .red),
            ],
            targetArrows: [
                Arrow(row: 0, col: 3, direction: .right, color: .blue),
                Arrow(row: 0, col: 4, direction: .right, color: .blue),
                Arrow(row: 0, col: 3, direction: .up,    color: .red),
                Arrow(row: 1, col: 3, direction: .up,    color: .red),
            ],
            parMoves: 3
        ))

        levels.append(Level(
            id: 24, title: "Lattice", gridSize: 6,
            initialArrows: [
                Arrow(row: 0, col: 0, direction: .right, color: .green),
                Arrow(row: 0, col: 3, direction: .down,  color: .orange),
                Arrow(row: 3, col: 5, direction: .left,  color: .green),
                Arrow(row: 3, col: 2, direction: .up,    color: .orange),
            ],
            targetArrows: [
                Arrow(row: 0, col: 2, direction: .right, color: .green),
                Arrow(row: 2, col: 3, direction: .down,  color: .orange),
                Arrow(row: 3, col: 3, direction: .left,  color: .green),
                Arrow(row: 1, col: 2, direction: .up,    color: .orange),
            ],
            parMoves: 4
        ))

        levels.append(Level(
            id: 25, title: "Roundabout", gridSize: 6,
            initialArrows: [
                Arrow(row: 0, col: 1, direction: .right, color: .red),
                Arrow(row: 1, col: 5, direction: .down,  color: .blue),
                Arrow(row: 5, col: 4, direction: .left,  color: .yellow),
                Arrow(row: 4, col: 0, direction: .up,    color: .purple),
            ],
            targetArrows: [
                Arrow(row: 0, col: 3, direction: .right, color: .red),
                Arrow(row: 3, col: 5, direction: .down,  color: .blue),
                Arrow(row: 5, col: 2, direction: .left,  color: .yellow),
                Arrow(row: 2, col: 0, direction: .up,    color: .purple),
            ],
            parMoves: 4
        ))

        // ── HARD PACK (26–30) ───────────────────────────────────────────────

        levels.append(Level(
            id: 26, title: "Gridlock", gridSize: 6,
            initialArrows: [
                Arrow(row: 0, col: 0, direction: .right, color: .red),
                Arrow(row: 0, col: 1, direction: .right, color: .red),
                Arrow(row: 0, col: 2, direction: .right, color: .red),
                Arrow(row: 5, col: 3, direction: .left,  color: .blue),
                Arrow(row: 5, col: 4, direction: .left,  color: .blue),
                Arrow(row: 5, col: 5, direction: .left,  color: .blue),
            ],
            targetArrows: [
                Arrow(row: 0, col: 3, direction: .right, color: .red),
                Arrow(row: 0, col: 4, direction: .right, color: .red),
                Arrow(row: 0, col: 5, direction: .right, color: .red),
                Arrow(row: 5, col: 0, direction: .left,  color: .blue),
                Arrow(row: 5, col: 1, direction: .left,  color: .blue),
                Arrow(row: 5, col: 2, direction: .left,  color: .blue),
            ],
            parMoves: 2
        ))

        levels.append(Level(
            id: 27, title: "Tangle", gridSize: 6,
            initialArrows: [
                Arrow(row: 1, col: 0, direction: .right, color: .green),
                Arrow(row: 1, col: 1, direction: .right, color: .yellow),
                Arrow(row: 4, col: 0, direction: .right, color: .purple),
                Arrow(row: 4, col: 1, direction: .right, color: .orange),
                Arrow(row: 2, col: 4, direction: .left,  color: .green),
                Arrow(row: 2, col: 5, direction: .left,  color: .yellow),
                Arrow(row: 3, col: 4, direction: .left,  color: .purple),
                Arrow(row: 3, col: 5, direction: .left,  color: .orange),
            ],
            targetArrows: [
                Arrow(row: 1, col: 4, direction: .right, color: .green),
                Arrow(row: 1, col: 5, direction: .right, color: .yellow),
                Arrow(row: 4, col: 4, direction: .right, color: .purple),
                Arrow(row: 4, col: 5, direction: .right, color: .orange),
                Arrow(row: 2, col: 0, direction: .left,  color: .green),
                Arrow(row: 2, col: 1, direction: .left,  color: .yellow),
                Arrow(row: 3, col: 0, direction: .left,  color: .purple),
                Arrow(row: 3, col: 1, direction: .left,  color: .orange),
            ],
            parMoves: 4
        ))

        levels.append(Level(
            id: 28, title: "Fortress", gridSize: 6,
            initialArrows: [
                Arrow(row: 0, col: 0, direction: .down,  color: .blue),
                Arrow(row: 0, col: 5, direction: .down,  color: .red),
                Arrow(row: 5, col: 0, direction: .up,    color: .red),
                Arrow(row: 5, col: 5, direction: .up,    color: .blue),
                Arrow(row: 2, col: 2, direction: .right, color: .green),
                Arrow(row: 2, col: 3, direction: .right, color: .green),
                Arrow(row: 3, col: 2, direction: .left,  color: .yellow),
                Arrow(row: 3, col: 3, direction: .left,  color: .yellow),
            ],
            targetArrows: [
                Arrow(row: 2, col: 0, direction: .down,  color: .blue),
                Arrow(row: 2, col: 5, direction: .down,  color: .red),
                Arrow(row: 3, col: 0, direction: .up,    color: .red),
                Arrow(row: 3, col: 5, direction: .up,    color: .blue),
                Arrow(row: 2, col: 2, direction: .right, color: .green),
                Arrow(row: 2, col: 3, direction: .right, color: .green),
                Arrow(row: 3, col: 2, direction: .left,  color: .yellow),
                Arrow(row: 3, col: 3, direction: .left,  color: .yellow),
            ],
            parMoves: 6
        ))

        levels.append(Level(
            id: 29, title: "Chaos", gridSize: 6,
            initialArrows: [
                Arrow(row: 0, col: 0, direction: .right, color: .red),
                Arrow(row: 0, col: 1, direction: .down,  color: .blue),
                Arrow(row: 1, col: 5, direction: .left,  color: .green),
                Arrow(row: 5, col: 4, direction: .up,    color: .yellow),
                Arrow(row: 3, col: 2, direction: .right, color: .purple),
                Arrow(row: 3, col: 3, direction: .left,  color: .orange),
            ],
            targetArrows: [
                Arrow(row: 0, col: 4, direction: .right, color: .red),
                Arrow(row: 4, col: 1, direction: .down,  color: .blue),
                Arrow(row: 1, col: 1, direction: .left,  color: .green),
                Arrow(row: 1, col: 4, direction: .up,    color: .yellow),
                Arrow(row: 3, col: 4, direction: .right, color: .purple),
                Arrow(row: 3, col: 1, direction: .left,  color: .orange),
            ],
            parMoves: 6
        ))

        levels.append(Level(
            id: 30, title: "Grand Finale", gridSize: 6,
            initialArrows: [
                Arrow(row: 0, col: 0, direction: .right, color: .red),
                Arrow(row: 0, col: 1, direction: .right, color: .orange),
                Arrow(row: 0, col: 2, direction: .right, color: .yellow),
                Arrow(row: 5, col: 3, direction: .left,  color: .green),
                Arrow(row: 5, col: 4, direction: .left,  color: .blue),
                Arrow(row: 5, col: 5, direction: .left,  color: .purple),
                Arrow(row: 2, col: 0, direction: .down,  color: .purple),
                Arrow(row: 3, col: 5, direction: .up,    color: .red),
            ],
            targetArrows: [
                Arrow(row: 0, col: 3, direction: .right, color: .red),
                Arrow(row: 0, col: 4, direction: .right, color: .orange),
                Arrow(row: 0, col: 5, direction: .right, color: .yellow),
                Arrow(row: 5, col: 0, direction: .left,  color: .green),
                Arrow(row: 5, col: 1, direction: .left,  color: .blue),
                Arrow(row: 5, col: 2, direction: .left,  color: .purple),
                Arrow(row: 4, col: 0, direction: .down,  color: .purple),
                Arrow(row: 1, col: 5, direction: .up,    color: .red),
            ],
            parMoves: 6
        ))

        return levels
    }
    // swiftlint:enable function_body_length
}
