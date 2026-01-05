//
//  ContentView.swift
//  Reply
//
//  Created by David Akhmedbayev on 1/5/26.
//

import SwiftUI

struct ContentView: View {
    @State private var generator = ResponseGenerator()
    @State private var input: String = ""
    @State private var selectedStyle: ResponseStyle = .professional
    
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
                } else {
                    // Response section
                    ResponseView(
                        response: $generator.currentResponse,
                        isGenerating: generator.isGenerating,
                        onRetry: {
                            Task {
                                await generator.retry(for: input, style: selectedStyle)
                            }
                        },
                        onCopy: {
                            copyToClipboard(generator.currentResponse)
                        }
                    )
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
        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 24))
    }
    
    private func copyToClipboard(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }
}

#Preview {
    ContentView()
}
