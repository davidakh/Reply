//
//  ResponseView.swift
//  Reply
//
//  Created by David Akhmedbayev on 1/5/26.
//

import SwiftUI

struct ResponseView: View {
    @Binding var response: String
    var isGenerating: Bool = false
    var onRetry: () -> Void
    var onCopy: () -> Void
    
    @State private var copyHover = false
    @State private var retryHover = false
    
    var body: some View {
        VStack {
            if isGenerating {
                Text("Generating...")
                    .transition(.blurReplace)
                    .foregroundStyle(.secondary)
                    .padding(12)
            } else {
                ScrollView {
                    Text(response)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .contentShape(Rectangle())
                        .transition(.blurReplace)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(minHeight: 80, maxHeight: 400)
            }
            
            optionBar
                .padding(8)
        }
        .textFieldStyle(.plain)
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var optionBar: some View {
        HStack(spacing: 2) {
            Spacer()
            
            // Retry button
            Button(action: {
                withAnimation {
                    onRetry()
                }
            }) {
                Image(systemName: "arrow.clockwise")
            }
                .font(.footnote)
                .fontWeight(.medium)
                .padding(6)
                .frame(maxHeight: 18)
                .background {
                    if retryHover {
                        Capsule()
                            .fill(.gray.opacity(0.25))
                    }
                }
                .clipShape(Capsule())
                .onHover { hovering in
                    withAnimation {
                        retryHover = hovering
                    }
                }
            
            // Copy button
            Button(action: {
                withAnimation {
                    onCopy()
                }
            }) {
                Image(systemName: "document.on.document")
            }
                .font(.footnote)
                .fontWeight(.medium)
                .padding(6)
                .frame(maxHeight: 18)
                .background {
                    if copyHover {
                        Capsule()
                            .fill(.gray.opacity(0.25))
                    }
                }
                .clipShape(Capsule())
                .onHover { hovering in
                    withAnimation {
                        copyHover = hovering
                    }
                }
        }
    }
}

#Preview {
    ResponseView(
        response: .constant("Hello, World!"),
        isGenerating: false,
        onRetry: {},
        onCopy: {}
    )
}
