import SwiftUI

@main
struct PrompITApp: App {
    @AppStorage("alwaysOnTop") private var alwaysOnTop = false
    @AppStorage("userOpacity") private var userOpacity = 1.0

    var body: some Scene {
        WindowGroup {
            ContentView(alwaysOnTop: $alwaysOnTop, userOpacity: $userOpacity)
                .opacity(userOpacity)
                .onAppear {
                    updateWindowLevel()
                }
                .onChange(of: alwaysOnTop) { _ in
                    updateWindowLevel()
                }
        }
    }

    private func updateWindowLevel() {
        guard let window = NSApplication.shared.windows.first else { return }
        configureFloatingWindow(window)
    }

    private func configureFloatingWindow(_ window: NSWindow) {
        window.level = alwaysOnTop ? .floating : .normal
    }
}

struct ContentView: View {
    @Binding var alwaysOnTop: Bool
    @Binding var userOpacity: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Toggle("Always on Top", isOn: $alwaysOnTop)
            HStack {
                Text("Opacity")
                Slider(value: $userOpacity, in: 0.5...1.0)
            }
        }
        .padding()
        .frame(minWidth: 320)
    }
}
