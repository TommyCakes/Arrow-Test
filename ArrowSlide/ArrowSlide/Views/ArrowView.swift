import SwiftUI

struct ArrowView: View {
    let arrow: Arrow
    let cellSize: CGFloat
    var isTarget: Bool = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cellSize * 0.18)
                .fill(isTarget ? arrow.color.color.opacity(0.18) : arrow.color.color)
                .overlay(
                    RoundedRectangle(cornerRadius: cellSize * 0.18)
                        .strokeBorder(
                            isTarget ? arrow.color.color.opacity(0.45) : arrow.color.darkColor,
                            lineWidth: isTarget ? 1.5 : 0
                        )
                )

            Image(systemName: "arrowtriangle.up.fill")
                .resizable()
                .scaledToFit()
                .padding(cellSize * 0.22)
                .foregroundColor(
                    isTarget ? arrow.color.color.opacity(0.55) : .white
                )
                .rotationEffect(.degrees(arrow.direction.angle))
        }
        .frame(width: cellSize * 0.82, height: cellSize * 0.82)
        .shadow(
            color: isTarget ? .clear : arrow.color.darkColor.opacity(0.35),
            radius: 3, x: 0, y: 2
        )
    }
}
