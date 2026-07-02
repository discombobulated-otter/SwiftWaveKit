import SwiftUI
import WaveKit

struct OceanEffectDemo: View {
    @State private var userAmp: Double = 1.0
    @State private var userFreq: Double = 2.0
    @State private var targetAmp: Double = 1.0
    @State private var targetFreq: Double = 2.5
    @State private var isAligning: Bool = false
    @State private var isAnimated: Bool = true
    
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
                    
                    let userFunction = WaveFunction.sine(frequency: userFreq)
                    let targetFunction = WaveFunction.sine(frequency: targetFreq)
                    
                    WaveView(userFunction)
                        .amplitude(userAmp)
                        .waveColor(.cyan)
                        .targetFunction(targetFunction)
                        .targetAmplitude(targetAmp)
                        .targetColor(.blue)
                        .showInterference(true)
                        .isAligning(isAligning)
                        .animated(isAnimated)
                        .renderMode3D(true)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                }
                .frame(height: 250)
                .padding(.horizontal, 20)
                
                VStack(spacing: 20) {
                    // Align Toggle
                    Toggle(isOn: $isAligning) {
                        HStack {
                            Image(systemName: "waveform.path")
                                .foregroundColor(.cyan)
                            Text("Overlap/Align Waves (Interference)")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical, 8)
                    .tint(.cyan)
                    
                    Divider().background(Color.white.opacity(0.1))
                    
                    VStack(spacing: 16) {
                        Text("User Wave Controls (Cyan)")
                            .font(.system(.caption, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.cyan)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        DemoSlider(title: "Amplitude", value: $userAmp, range: 0.2...2.0, format: "%.2f")
                        DemoSlider(title: "Frequency", value: $userFreq, range: 0.5...5.0, format: "%.1f")
                    }
                    
                    Divider().background(Color.white.opacity(0.1))
                    
                    VStack(spacing: 16) {
                        Text("Target Wave Controls (Blue)")
                            .font(.system(.caption, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        DemoSlider(title: "Amplitude", value: $targetAmp, range: 0.2...2.0, format: "%.2f")
                        DemoSlider(title: "Frequency", value: $targetFreq, range: 0.5...5.0, format: "%.1f")
                    }
                }
                .padding(25)
                .background(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.white.opacity(0.04))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                
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
