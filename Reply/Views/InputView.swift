//
//  InputView.swift
//  Reply
//
//  Created by David Akhmedbayev on 1/5/26.
//

import SwiftUI

struct InputView: View {
    @Binding var input: String
    @Binding var selectedStyle: ResponseStyle
    var onGenerate: () -> Void
    
    @FocusState var selected: Bool
    @State private var styleHover = false
    
    var body: some View {
        VStack(spacing: 4) {
            inputBar
            optionBar
        }
        .padding(8)
        .textFieldStyle(.plain)
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var inputBar: some View {
        HStack(alignment: .bottom) {
            TextField("Message...", text: $input, axis: .vertical)
                .lineLimit(1...6)
                .fixedSize(horizontal: false, vertical: true)
                .padding(8)
                .focused($selected)
                .onKeyPress(.return, phases: .down) { keyPress in
                    if keyPress.modifiers.contains(.command) {
                        if !input.isEmpty {
                            onGenerate()
                            return .handled
                        }
                    }
                    return .ignored
                }
            
            Button(action: {
                withAnimation {
                    if !input.isEmpty {
                        onGenerate()
                    }
                }
            }) {
                Image(systemName: "arrow.up")
            }
            .padding(8)
            .bold()
            .disabled(input.isEmpty)
        }
        .background {
            if selected {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.clear)
                    .background(Material.regular, in: RoundedRectangle(cornerRadius: 16))
                    .intelligence(active: true, spread: 0, blur: 8, opacity: 1, shape: RoundedRectangle(cornerRadius: 16))
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
            }
        }
    }
    
    @ViewBuilder
    private var optionBar: some View {
        HStack {
            Menu {
                ForEach(ResponseStyle.allCases) { style in
                    Button(action: {
                        selectedStyle = style
                    }) {
                        HStack(spacing: 0) {
                            Image(systemName: style.icon)
                            Text(style.rawValue)
                        }
                    }
                }
            } label: {
                HStack(spacing: 2) {
                    Image(systemName: selectedStyle.icon)
                    Text(selectedStyle.rawValue)
                }
                .font(.footnote)
                .fontWeight(.medium)
                .padding(.leading, 3)
                .padding(.trailing, 6)
                .frame(maxHeight: 18)
                .background(styleHover ? Color.gray.opacity(0.25) : Color.clear)
                .clipShape(Capsule())
                .onHover { hovering in
                    withAnimation {
                        styleHover = hovering
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    InputView(
        input: .constant(""),
        selectedStyle: .constant(.professional),
        onGenerate: {}
    )
}
