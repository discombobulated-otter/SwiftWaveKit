import SwiftUI
import WaveKit

struct OceanEffectDemo: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.08, green: 0.08, blue: 0.18), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("Ocean & Interference")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Align waves to overlap and observe interference")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding(.top, 15)
                
                // 3D Interference Wave using WaveView + modifiers
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.white.opacity(0.04))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                    
                    let userFunction = WaveFunction.sine(frequency: 2.0)
                    let targetFunction = WaveFunction.sine(frequency: 2.5)
                    
                    WaveView(userFunction)
                        .waveform(amplitude: 1.0)
                        .waveStyle(WaveStyle(color: .cyan))
                        .interference(with: TargetWave(function: targetFunction, amplitude: 1.0, frequency: 2.5, color: .blue))
                        .isAligning(true)
                        .animated(speed: 1.0)
                        .gridStyle(.subtle)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                }
                .frame(height: 250)
                .padding(.horizontal, 20)
                
                CodeSnippetView(code: """
                let userFunction = WaveFunction.sine(frequency: 2.0)
                let targetFunction = WaveFunction.sine(frequency: 2.5)
                
                WaveView(userFunction)
                    .waveform(amplitude: 1.0)
                    .waveStyle(WaveStyle(color: .cyan))
                    .interference(with: TargetWave(
                        function: targetFunction,
                        amplitude: 1.0,
                        frequency: 2.5,
                        color: .blue
                    ))
                    .isAligning(true)
                """)
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OceanEffectDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OceanEffectDemo()
        }
    }
}
