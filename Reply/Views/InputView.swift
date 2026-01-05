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
        HStack {
            TextField("Message...", text: $input)
                .padding(8)
                .focused($selected)
                .onSubmit {
                    if !input.isEmpty {
                        onGenerate()
                    }
                }
            
            Button(action: {
                if !input.isEmpty {
                    onGenerate()
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
                        Label(style.rawValue, systemImage: style.icon)
                    }
                }
            } label: {
                HStack {
                    Label(selectedStyle.rawValue, systemImage: selectedStyle.icon)
                        .font(.footnote)
                        .fontWeight(.medium)
                }
                .padding(6)
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
