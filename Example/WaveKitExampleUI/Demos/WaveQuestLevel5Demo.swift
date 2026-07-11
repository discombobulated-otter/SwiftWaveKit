import SwiftUI
import WaveKit

struct WaveQuestLevel5Demo: View {
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
                    Text("Amplitude Modulation")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("WaveQuest Level 5: Modulated signal envelope")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                // 3D Modulated Wave using WaveView + modifiers
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.white.opacity(0.04))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                    
                    let carrier = WaveFunction.sine(frequency: 5.0)
                    let modulator = WaveFunction { x in 1.0 + 0.8 * sin(0.5 * x) }
                    let combined = modulator * carrier
                    
                    WaveView(combined)
                        .waveform(amplitude: 1.2)
                        .waveStyle(WaveStyle(color: .purple))
                        .animated(speed: 1.0)
                        .gridStyle(.dense)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                }
                .frame(height: 280)
                .padding(.horizontal, 20)
                
                CodeSnippetView(code: """
                let carrier = WaveFunction.sine(frequency: 5.0)
                let modulator = WaveFunction { x in 
                    1.0 + 0.8 * sin(0.5 * x) 
                }
                let combined = modulator * carrier
                
                WaveView(combined)
                    .waveform(amplitude: 1.2)
                    .waveStyle(WaveStyle(color: .purple))
                    .animated(speed: 1.0)
                    .gridStyle(.dense)
                """)
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WaveQuestLevel5Demo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WaveQuestLevel5Demo()
        }
    }
}
