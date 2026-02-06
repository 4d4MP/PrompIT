import AppKit
import SwiftUI

@main
struct PrompITApp: App {
    var body: some Scene {
        WindowGroup {
            TeleprompterView()
        }
        .windowStyle(.hiddenTitleBar)

        Settings {
            SettingsView()
        }
    }
}

private struct TeleprompterView: View {
    @Environment(\.openSettings) private var openSettings
    @AppStorage("scriptMarkdown") private var scriptMarkdown = ""
    @AppStorage("fontSize") private var fontSize = 28.0
    @AppStorage("lineSpacing") private var lineSpacing = 6.0
    @AppStorage("textIsLight") private var textIsLight = true
    @AppStorage("darkBackground") private var darkBackground = true
    @AppStorage("windowOpacity") private var windowOpacity = 1.0
    @AppStorage("alwaysOnTop") private var alwaysOnTop = true

    private let placeholderText = "Add your script in Settings to start prompting."

    var body: some View {
        ZStack(alignment: .topTrailing) {
            backgroundColor.ignoresSafeArea()
            ScrollView {
                Text(displayText)
                    .font(.system(size: fontSize))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(lineSpacing)
                    .padding(40)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Button {
                openSettings()
            } label: {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(textColor.opacity(0.8))
                    .padding(10)
                    .background(backgroundColor.opacity(0.6))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .padding(16)
            .accessibilityLabel("Open Settings")
        }
        .background(WindowAccessor { window in
            configureFloatingWindow(window)
        })
    }

    private func configureFloatingWindow(_ window: NSWindow) {
        window.level = alwaysOnTop ? .floating : .normal
        window.isMovableByWindowBackground = true
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.alphaValue = windowOpacity
    }

    private var displayText: AttributedString {
        let markdown = scriptMarkdown.trimmingCharacters(in: .whitespacesAndNewlines)
        if markdown.isEmpty {
            return AttributedString(placeholderText)
        }
        return (try? AttributedString(markdown: markdown, options: .init(interpretedSyntax: .inlineOnly))) ?? AttributedString(markdown)
    }

    private var textColor: Color {
        textIsLight ? .white : .black
    }

    private var backgroundColor: Color {
        darkBackground ? .black : .white
    }
}

private struct SettingsView: View {
    @AppStorage("scriptMarkdown") private var scriptMarkdown = ""
    @AppStorage("fontSize") private var fontSize = 28.0
    @AppStorage("lineSpacing") private var lineSpacing = 6.0
    @AppStorage("textIsLight") private var textIsLight = true
    @AppStorage("darkBackground") private var darkBackground = true
    @AppStorage("windowOpacity") private var windowOpacity = 1.0
    @AppStorage("alwaysOnTop") private var alwaysOnTop = true

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            GroupBox("Script (Markdown)") {
                TextEditor(text: $scriptMarkdown)
                    .font(.body)
                    .frame(minHeight: 220)
                    .padding(.vertical, 4)
            }

            GroupBox("Appearance") {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Font Size")
                        Slider(value: $fontSize, in: 16...64, step: 1)
                        Text("\(Int(fontSize)) pt")
                            .frame(width: 60, alignment: .trailing)
                    }
                    HStack {
                        Text("Line Spacing")
                        Slider(value: $lineSpacing, in: 0...20, step: 1)
                        Text("\(Int(lineSpacing))")
                            .frame(width: 60, alignment: .trailing)
                    }
                    Toggle("Light Text", isOn: $textIsLight)
                    Toggle("Dark Background", isOn: $darkBackground)
                    HStack {
                        Text("Window Opacity")
                        Slider(value: $windowOpacity, in: 0.6...1.0, step: 0.05)
                        Text(String(format: "%.0f%%", windowOpacity * 100))
                            .frame(width: 60, alignment: .trailing)
                    }
                }
                .padding(.vertical, 4)
            }

            GroupBox("Behavior") {
                Toggle("Always On Top", isOn: $alwaysOnTop)
                    .padding(.vertical, 4)
            }

            Spacer()
        }
        .padding(20)
        .frame(minWidth: 480, minHeight: 520)
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
