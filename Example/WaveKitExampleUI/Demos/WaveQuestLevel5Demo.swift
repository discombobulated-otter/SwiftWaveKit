import SwiftUI
import WaveKit

struct WaveQuestLevel5Demo: View {
    @State private var carrierFreq: Double = 5.0
    @State private var modDepth: Double = 0.8
    @State private var modFreq: Double = 0.5
    @State private var isAnimated: Bool = true
    @State private var showGrid: Bool = true
    
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
                    
                    let carrier = WaveFunction.sine(frequency: carrierFreq)
                    let currentDepth = modDepth
                    let currentFreq = modFreq
                    let modulator = WaveFunction { x in 1.0 + currentDepth * sin(currentFreq * x) }
                    let combined = modulator * carrier
                    
                    WaveView(combined)
                        .amplitude(1.2)
                        .waveColor(.purple)
                        .animated(isAnimated)
                        .renderMode3D(true)
                        .showGrid(showGrid)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                }
                .frame(height: 280)
                .padding(.horizontal, 20)
                
                VStack(spacing: 24) {
                    DemoSlider(title: "Carrier Frequency", value: $carrierFreq, range: 1.0...10.0, format: "%.1f")
                    DemoSlider(title: "Modulation Depth", value: $modDepth, range: 0.0...1.0, format: "%.2f")
                    DemoSlider(title: "Modulation Frequency", value: $modFreq, range: 0.1...2.0, format: "%.2f")
                    
                    HStack(spacing: 30) {
                        Toggle(isOn: $isAnimated) {
                            Text("Animate")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        
                        Toggle(isOn: $showGrid) {
                            Text("Show Grid")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                    }
                    .tint(.purple)
                }
                .padding(30)
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

struct WaveQuestLevel5Demo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WaveQuestLevel5Demo()
        }
    }
}
