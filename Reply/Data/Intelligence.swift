//
//  Intelligence.swift
//  Bible
//
//  Created by David Akhmedbayev on 12/14/25.
//

import SwiftUI

private let colors: [Color] = [.blue, .purple, .red, .orange, .yellow, .cyan, .blue, .purple]

struct IntelligenceViewModifier<S: Shape>: ViewModifier {
    @State private var offset: CGFloat = 0
    
    var active: Bool
    var shape: S
    var spread: CGFloat
    var blur: CGFloat
    var opacity: CGFloat
    var speed: Double
    
    func body(content: Content) -> some View {
        content
            .background {
                if active {
                    shape
                        .fill(LinearGradient(
                            colors: colors,
                            startPoint: UnitPoint(x: offset, y: 0),
                            endPoint: UnitPoint(x: CGFloat(colors.count) + offset, y: 0))
                        )
                        .padding(-spread)
                        .blur(radius: blur)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.linear(duration: speed).repeatForever(autoreverses: false)) {
                                offset = -CGFloat(colors.count - 1)
                            }
                        }
                        .onChange(of: active) { _, newValue in
                            if newValue {
                                withAnimation(.linear(duration: speed).repeatForever(autoreverses: false)) {
                                    offset = -CGFloat(colors.count - 1)
                                }
                            } else {
                                offset = 0
                            }
                        }
                }
            }
    }
}

public extension View {
    func intelligence<S: Shape>(
        active: Bool = true,
        spread: CGFloat = 0,
        blur: CGFloat = 8,
        opacity: CGFloat = 1.0,
        speed: Double = 10.0,
        shape: S
    ) -> some View {
        modifier(IntelligenceViewModifier(
            active: active,
            shape: shape,
            spread: spread,
            blur: blur,
            opacity: opacity,
            speed: speed
        ))
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var active = true
        @State private var opacity: Double = 1.0
        @State private var speed: Double = 10.0
        
        var body: some View {
            VStack(spacing: 32) {
                Toggle("Enable Intelligence Effect", isOn: $active)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text("Opacity: \(opacity, specifier: "%.2f")")
                    Slider(value: $opacity, in: 0...1)
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Speed: \(speed, specifier: "%.1f")s")
                    Slider(value: $speed, in: 1...20)
                }
                .padding()
                
                Circle()
                    .frame(width: 100, height: 100)
                    .intelligence(active: active, spread: 0, blur: 8, opacity: opacity, speed: speed, shape: Circle())
                
                Text("Button")
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 32)
                    .padding(.vertical)
                    .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .foregroundStyle(.secondary)
                    .intelligence(active: active, spread: 0, blur: 4, opacity: opacity, speed: speed, shape: RoundedRectangle(cornerRadius: 16))
            }
            .fixedSize(horizontal: true, vertical: false)
            .padding()
        }
    }
    
    return PreviewWrapper()
}
