import SwiftUI
import WaveKit

struct BasicSineDemo: View {
    @State private var amplitude: Double = 1.0
    @State private var frequency: Double = 2.0
    @State private var isAnimated: Bool = true
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(red: 0.08, green: 0.08, blue: 0.18), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 8) {
                    Text("Basic Sine Wave")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Single pure tone frequency visualizer")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                // 3D Wave Box using WaveView + modifiers
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.white.opacity(0.04))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                    
                    WaveView(.sine)
                        .amplitude(amplitude)
                        .frequency(frequency)
                        .waveColor(.cyan)
                        .animated(isAnimated)
                        .renderMode3D(true)
                        .isPureTone(true)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                }
                .frame(height: 280)
                .padding(.horizontal, 20)
                
                // Controls Panel
                VStack(spacing: 24) {
                    DemoSlider(title: "Amplitude", value: $amplitude, range: 0.1...2.5, format: "%.2f")
                    DemoSlider(title: "Frequency", value: $frequency, range: 0.5...6.0, format: "%.1f")
                    
                    Toggle(isOn: $isAnimated) {
                        Text("Animate Movement")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .tint(.cyan)
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

struct DemoSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    var format: String = "%.2f"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                Spacer()
                Text(String(format: format, value))
                    .font(.system(.subheadline, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Slider(value: $value, in: range)
                .tint(.cyan)
        }
    }
}

struct BasicSineDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BasicSineDemo()
        }
    }
}
