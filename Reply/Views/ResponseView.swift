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
    
    @State private var rateHover = false
    @State private var copyHover = false
    @State private var retryHover = false
    @State private var thumbsUpSelected = false
    @State private var thumbsDownSelected = false
    
    var body: some View {
        VStack {
            if isGenerating {
                Text("Generating...")
            } else {
                Text(response)
                    .multilineTextAlignment(.leading)
                    .contentShape(Rectangle())
            }
            
            optionBar
        }
        .padding(8)
        .textFieldStyle(.plain)
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var optionBar: some View {
        HStack {
            // Rating buttons
            HStack {
                Button(action: {
                    thumbsUpSelected.toggle()
                    if thumbsUpSelected {
                        thumbsDownSelected = false
                    }
                }) {
                    Image(systemName: thumbsUpSelected ? "hand.thumbsup.fill" : "hand.thumbsup")
                }
                
                Divider()
                
                Button(action: {
                    thumbsDownSelected.toggle()
                    if thumbsDownSelected {
                        thumbsUpSelected = false
                    }
                }) {
                    Image(systemName: thumbsDownSelected ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                }
            }
                .font(.footnote)
                .fontWeight(.medium)
                .padding(6)
                .frame(maxHeight: 18)
                .background {
                    if rateHover {
                        Capsule()
                            .fill(.gray.opacity(0.25))
                    }
                }
                .clipShape(Capsule())
                .onHover { hovering in
                    withAnimation {
                        rateHover = hovering
                    }
                }
            
            // Retry button
            Button(action: {
                onRetry()
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
            
            Spacer()
            
            // Copy button
            Button(action: {
                onCopy()
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
