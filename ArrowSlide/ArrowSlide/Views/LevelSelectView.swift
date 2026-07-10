import SwiftUI

struct LevelSelectView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var selectedLevel: Level?

    private let packs: [(String, ClosedRange<Int>)] = [
        ("Tutorial",  1...5),
        ("Easy",      6...15),
        ("Medium",    16...25),
        ("Hard",      26...30),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    ForEach(packs, id: \.0) { pack in
                        packSection(title: pack.0, range: pack.1)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("ArrowSlide")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(item: $selectedLevel) { level in
                GameView(level: level)
                    .environmentObject(progress)
            }
        }
    }

    // MARK: - Pack section

    private func packSection(title: String, range: ClosedRange<Int>) -> some View {
        let levels = Level.all.filter { range.contains($0.id) }

        return VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.weight(.bold))
                .padding(.leading, 4)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80, maximum: 100), spacing: 12)], spacing: 12) {
                ForEach(levels) { level in
                    levelCell(level: level)
                }
            }
        }
    }

    // MARK: - Level cell

    private func levelCell(level: Level) -> some View {
        let unlocked = progress.isUnlocked(level)
        let done = progress.completed.contains(level.id)
        let best = progress.bestMoves[level.id]

        return Button {
            if unlocked { selectedLevel = level }
        } label: {
            VStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(done ? Color.accentColor : (unlocked ? Color(.secondarySystemBackground) : Color(.tertiarySystemBackground)))

                    if !unlocked {
                        Image(systemName: "lock.fill")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    } else {
                        VStack(spacing: 2) {
                            Text("\(level.id)")
                                .font(.title2.weight(.black))
                                .foregroundColor(done ? .white : .primary)

                            if done, let b = best {
                                HStack(spacing: 2) {
                                    ForEach(1...3, id: \.self) { i in
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 9))
                                            .foregroundColor(i <= stars(level: level, best: b) ? .yellow : .white.opacity(0.4))
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(height: 72)

                Text(level.title)
                    .font(.caption2)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
            }
        }
        .disabled(!unlocked)
    }

    private func stars(level: Level, best: Int) -> Int {
        let par = level.parMoves
        if best <= par { return 3 }
        if best <= par + par / 2 { return 2 }
        return 1
    }
}
