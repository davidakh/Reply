//
//  ContentView.swift
//  Reply
//
//  Created by David Akhmedbayev on 1/5/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var generator = ResponseGenerator()
    @State private var input: String = ""
    @State private var selectedStyle: ResponseStyle = .casual
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if generator.currentResponse.isEmpty {
                    // Input section
                    InputView(
                        input: $input,
                        selectedStyle: $selectedStyle,
                        onGenerate: {
                            Task {
                                await generator.generateResponse(for: input, style: selectedStyle)
                            }
                        }
                    )
                    .transition(.blurReplace)
                } else {
                    // Response section
                    ResponseView(
                        response: $generator.currentResponse,
                        isGenerating: generator.isGenerating,
                        onRetry: {
                            resetState()
                        },
                        onCopy: {
                            copyToClipboard(generator.currentResponse)
                            
                            resetState()
                        }
                    )
                    .transition(.blurReplace)
                }
            
                // Error message
                if let error = generator.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.caption)
                        .padding()
                }
            }
        }
        .intelligence(active: generator.isGenerating, opacity: 0.25, shape: RoundedRectangle(cornerRadius: 24))
        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 24))
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background || newPhase == .inactive {
                resetState()
            }
        }
    }
    
    private func resetState() {
        generator.clear()
    }
    
    private func copyToClipboard(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }
}

#Preview {
    ContentView()
}
