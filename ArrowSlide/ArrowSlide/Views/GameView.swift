import SwiftUI

struct GameView: View {
    let level: Level
    @StateObject private var engine: GameEngine
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss

    @State private var showSolvedOverlay = false
    @State private var showResetConfirm = false
    @State private var starCount = 0

    init(level: Level) {
        self.level = level
        _engine = StateObject(wrappedValue: GameEngine(level: level))
    }

    var body: some View {
        GeometryReader { geo in
            let maxGridWidth = min(geo.size.width - 32, geo.size.height - 200)
            let cellSize = maxGridWidth / CGFloat(level.gridSize)

            VStack(spacing: 0) {
                // Header
                header
                    .padding(.horizontal)
                    .padding(.top, 8)

                Spacer(minLength: 0)

                // Grid
                GridView(engine: engine, cellSize: cellSize)
                    .padding(.horizontal, 16)

                Spacer(minLength: 0)

                // Toolbar
                toolbar
                    .padding(.horizontal)
                    .padding(.bottom, geo.safeAreaInsets.bottom + 12)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .onChange(of: engine.isSolved) { solved in
            if solved {
                starCount = computeStars()
                progress.record(levelId: level.id, moves: engine.moves)
                withAnimation(.spring()) { showSolvedOverlay = true }
            }
        }
        .overlay {
            if showSolvedOverlay {
                SolvedOverlay(
                    level: level,
                    moves: engine.moves,
                    par: level.parMoves,
                    stars: starCount,
                    onReplay: {
                        showSolvedOverlay = false
                        engine.reset()
                    },
                    onNext: {
                        dismiss()
                    }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.85)))
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.primary)
                    .frame(width: 36, height: 36)
                    .background(Color(.tertiarySystemBackground), in: Circle())
            }

            Spacer()

            VStack(spacing: 2) {
                Text("Level \(level.id)")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Text(level.title)
                    .font(.headline)
            }

            Spacer()

            // Moves counter
            VStack(spacing: 2) {
                Text("\(engine.moves)")
                    .font(.title2.weight(.bold))
                    .monospacedDigit()
                Text("moves")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(width: 60, alignment: .trailing)
        }
    }

    // MARK: - Toolbar

    private var toolbar: some View {
        HStack(spacing: 20) {
            toolbarButton("arrow.uturn.backward", label: "Undo") {
                engine.undo()
            }
            .disabled(engine.moves == 0)

            Spacer()

            VStack(spacing: 2) {
                Text("Par: \(level.parMoves)")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                if let best = progress.bestMoves[level.id] {
                    Text("Best: \(best)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            toolbarButton("arrow.counterclockwise", label: "Reset") {
                showResetConfirm = true
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 24)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
        .confirmationDialog("Reset puzzle?", isPresented: $showResetConfirm, titleVisibility: .visible) {
            Button("Reset", role: .destructive) { engine.reset() }
            Button("Cancel", role: .cancel) { }
        }
    }

    private func toolbarButton(_ icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.title3)
                Text(label)
                    .font(.caption2)
            }
            .foregroundColor(.primary)
            .frame(width: 56, height: 44)
        }
    }

    // MARK: - Stars

    private func computeStars() -> Int {
        let moves = engine.moves
        let par = level.parMoves
        if moves <= par { return 3 }
        if moves <= par + par / 2 { return 2 }
        return 1
    }
}

// MARK: - Solved overlay

struct SolvedOverlay: View {
    let level: Level
    let moves: Int
    let par: Int
    let stars: Int
    let onReplay: () -> Void
    let onNext: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.45).ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Solved!")
                    .font(.system(size: 40, weight: .black, design: .rounded))

                // Stars
                HStack(spacing: 8) {
                    ForEach(1...3, id: \.self) { i in
                        Image(systemName: i <= stars ? "star.fill" : "star")
                            .font(.system(size: 36))
                            .foregroundColor(i <= stars ? .yellow : .gray.opacity(0.4))
                    }
                }

                // Stats
                HStack(spacing: 32) {
                    statBadge(label: "Moves", value: "\(moves)")
                    statBadge(label: "Par", value: "\(par)")
                }

                // Buttons
                HStack(spacing: 16) {
                    Button(action: onReplay) {
                        Label("Replay", systemImage: "arrow.counterclockwise")
                            .font(.body.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(.tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
                    }
                    .foregroundColor(.primary)

                    Button(action: onNext) {
                        Label("Next", systemImage: "chevron.right")
                            .font(.body.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 14))
                    }
                    .foregroundColor(.white)
                }
            }
            .padding(32)
            .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 28))
            .padding(.horizontal, 28)
        }
    }

    private func statBadge(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title.weight(.bold))
                .monospacedDigit()
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
