import SwiftUI
import WaveKit

struct MultipleWavesDemo: View {
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
                    Text("Layered & Composite Waves")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Interference and superposition of frequencies")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                // 3D Composite Wave using WaveView + modifiers
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.white.opacity(0.04))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                    
                    let combined = (WaveFunction.sine(frequency: 1.5) + WaveFunction.cosine(frequency: 3.0)) * 0.6
                    
                    WaveView(combined)
                        .waveform(amplitude: 1.0)
                        .waveStyle(WaveStyle(color: .white))
                        .animated(speed: 1.0)
                        .gridStyle(.dense)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                }
                .frame(height: 280)
                .padding(.horizontal, 20)
                
                CodeSnippetView(code: """
                let combined = (
                    WaveFunction.sine(frequency: 1.5) + 
                    WaveFunction.cosine(frequency: 3.0)
                ) * 0.6
                
                WaveView(combined)
                    .waveform(amplitude: 1.0)
                    .waveStyle(WaveStyle(color: .white))
                    .animated(speed: 1.0)
                    .gridStyle(.dense)
                """)
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MultipleWavesDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MultipleWavesDemo()
        }
    }
}
