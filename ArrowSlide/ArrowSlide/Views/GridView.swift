import SwiftUI

struct GridView: View {
    @ObservedObject var engine: GameEngine
    let cellSize: CGFloat

    // drag state
    @State private var dragStart: CGPoint = .zero
    @State private var activeAxis: SlideAxis?
    @State private var cumulativeDelta: CGFloat = 0
    @State private var lastStep: Int = 0

    private var gridSize: Int { engine.level.gridSize }
    private var totalSize: CGFloat { cellSize * CGFloat(gridSize) }

    var body: some View {
        ZStack {
            // Background grid lines
            gridLines

            // Target ghost arrows
            ForEach(engine.level.targetArrows) { target in
                ArrowView(arrow: target, cellSize: cellSize, isTarget: true)
                    .position(position(row: target.row, col: target.col))
            }

            // Live arrows
            ForEach(engine.arrows) { arrow in
                ArrowView(arrow: arrow, cellSize: cellSize)
                    .position(position(row: arrow.row, col: arrow.col))
                    .animation(.interactiveSpring(response: 0.22, dampingFraction: 0.7), value: arrow.row)
                    .animation(.interactiveSpring(response: 0.22, dampingFraction: 0.7), value: arrow.col)
            }
        }
        .frame(width: totalSize, height: totalSize)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)
        )
        .gesture(dragGesture)
        .disabled(engine.isSolved)
    }

    // MARK: - Grid lines

    private var gridLines: some View {
        Canvas { ctx, size in
            let n = CGFloat(gridSize)
            let step = size.width / n
            var path = Path()
            for i in 0...gridSize {
                let x = CGFloat(i) * step
                let y = CGFloat(i) * step
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
            }
            ctx.stroke(path, with: .color(.secondary.opacity(0.15)), lineWidth: 1)
        }
    }

    // MARK: - Position helper

    private func position(row: Int, col: Int) -> CGPoint {
        CGPoint(
            x: (CGFloat(col) + 0.5) * cellSize,
            y: (CGFloat(row) + 0.5) * cellSize
        )
    }

    // MARK: - Drag gesture

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                if activeAxis == nil {
                    dragStart = value.startLocation
                    cumulativeDelta = 0
                    lastStep = 0
                    // Determine row/col from where user started
                    let touchCol = Int(dragStart.x / cellSize)
                    let touchRow = Int(dragStart.y / cellSize)
                    let dx = abs(value.translation.width)
                    let dy = abs(value.translation.height)
                    if dx > dy {
                        activeAxis = .row(clamp(touchRow, 0, gridSize - 1))
                    } else {
                        activeAxis = .col(clamp(touchCol, 0, gridSize - 1))
                    }
                }

                guard let axis = activeAxis else { return }

                switch axis {
                case .row:
                    cumulativeDelta = value.translation.width
                case .col:
                    cumulativeDelta = value.translation.height
                }

                let step = Int((cumulativeDelta / cellSize).rounded(.towardZero))
                let diff = step - lastStep
                if diff != 0 {
                    engine.slide(axis: axis, delta: diff)
                    lastStep = step
                }
            }
            .onEnded { _ in
                activeAxis = nil
                cumulativeDelta = 0
                lastStep = 0
            }
    }

    private func clamp(_ v: Int, _ lo: Int, _ hi: Int) -> Int {
        min(max(v, lo), hi)
    }
}
