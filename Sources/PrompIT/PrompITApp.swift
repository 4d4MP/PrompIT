import AppKit
import SwiftUI

@main
struct PrompITApp: App {
    var body: some Scene {
        WindowGroup {
            TeleprompterView()
        }
        .windowStyle(.hiddenTitleBar)
    }
}

private struct TeleprompterView: View {
    private let placeholderText = "Add your script in Settings to start prompting."

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text(placeholderText)
                .font(.title2)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(40)
        }
        .background(WindowAccessor { window in
            configureFloatingWindow(window)
        })
    }

    private func configureFloatingWindow(_ window: NSWindow) {
        window.level = .floating
        window.isMovableByWindowBackground = true
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
    }
}

private struct WindowAccessor: NSViewRepresentable {
    let onWindowChange: (NSWindow) -> Void

    func makeNSView(context: Context) -> NSView {
        NSView()
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        guard let window = nsView.window else { return }
        onWindowChange(window)
    }
}
