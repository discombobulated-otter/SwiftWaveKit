import SwiftUI
import WaveKit

struct DampedWaveDemo: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.08, green: 0.08, blue: 0.18), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack(spacing: 8) {
                    Text("Damped Wave")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Exponential decay of amplitude over distance")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                // 3D Damped Wave using WaveView + modifiers
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.white.opacity(0.04))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                    
                    let function = WaveFunction.damped(decay: 0.2, frequency: 3.0)
                    
                    WaveView(function)
                        .waveform(amplitude: 1.5, frequency: 3.0)
                        .waveStyle(WaveStyle(color: .orange))
                        .animated(speed: 1.0)
                        .gridStyle(.dense)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                }
                .frame(height: 280)
                .padding(.horizontal, 20)
                
                CodeSnippetView(code: """
                let function = WaveFunction.damped(
                    decay: 0.2, frequency: 3.0
                )
                
                WaveView(function)
                    .waveform(amplitude: 1.5, frequency: 3.0)
                    .waveStyle(WaveStyle(color: .orange))
                    .animated(speed: 1.0)
                    .gridStyle(.dense)
                """)
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DampedWaveDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DampedWaveDemo()
        }
    }
}
