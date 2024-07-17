import SwiftUI

typealias Action = (UISwipeGestureRecognizer.Direction) -> Void

struct SwipeRecognizerView: UIViewRepresentable {
    let action: Action

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let swipeDirections: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]

        for direction in swipeDirections {
            let swipeRecognizer = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.respondToSwipeGesture))
            swipeRecognizer.direction = direction
            view.addGestureRecognizer(swipeRecognizer)
        }

        return view
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        let action: Action

        init(action: @escaping Action) {
            self.action = action
        }

        @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
            guard let swipeGesture = gesture as? UISwipeGestureRecognizer else { return }
            action(swipeGesture.direction)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

// MARK: - Swipe modifier

struct SwipeModifier: ViewModifier {
    let action: Action

    func body(content: Content) -> some View {
        content
            .overlay {
                SwipeRecognizerView(action: action)
                    .focusable()
            }
    }
}

extension View {
    func onSwipeGesture(perform: @escaping Action) -> some View {
        modifier(SwipeModifier(action: perform))
    }
}
