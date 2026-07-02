import SwiftUI
import WaveKit

struct DampedWaveDemo: View {
    @State private var decay: Double = 0.2
    @State private var frequency: Double = 3.0
    @State private var amplitude: Double = 1.5
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
                    
                    let function = WaveFunction.damped(decay: decay, frequency: frequency)
                    
                    WaveView(function)
                        .amplitude(amplitude)
                        .waveColor(.orange)
                        .animated(isAnimated)
                        .renderMode3D(true)
                        .showGrid(showGrid)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                }
                .frame(height: 280)
                .padding(.horizontal, 20)
                
                VStack(spacing: 24) {
                    DemoSlider(title: "Decay Rate (Damping)", value: $decay, range: 0.0...0.8, format: "%.2f")
                    DemoSlider(title: "Base Amplitude", value: $amplitude, range: 0.5...2.5, format: "%.2f")
                    DemoSlider(title: "Frequency", value: $frequency, range: 1.0...6.0, format: "%.1f")
                    
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
                    .tint(.orange)
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

struct DampedWaveDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DampedWaveDemo()
        }
    }
}
