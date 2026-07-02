import SwiftUI
import WaveKit

struct ECGStyleDemo: View {
    @State private var heartRate: Double = 60.0
    @State private var amplitude: Double = 1.0
    @State private var isAnimated: Bool = true
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.04, green: 0.08, blue: 0.06), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack(spacing: 8) {
                    Text("3D ECG Heartbeat")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Simulated cardiac electrical activity")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                // 3D ECG using WaveView + modifiers
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.white.opacity(0.04))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                    
                    WaveView(ecgFunction)
                        .amplitude(amplitude)
                        .waveColor(.green)
                        .animated(isAnimated)
                        .renderMode3D(true)
                        .isECG(true)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                }
                .frame(height: 280)
                .padding(.horizontal, 20)
                
                VStack(spacing: 24) {
                    DemoSlider(title: "Signal Amplitude", value: $amplitude, range: 0.2...2.0, format: "%.2f")
                    
                    HStack(alignment: .center) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.green)
                            .symbolEffect(.pulse, options: .repeating, value: isAnimated)
                        
                        Text("Simulating Heart Activity")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Toggle("", isOn: $isAnimated)
                            .labelsHidden()
                            .tint(.green)
                    }
                    .padding(.vertical, 8)
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
    
    // Fallback ECG wave definition (used if ever rendered in 2D)
    var ecgFunction: WaveFunction {
        WaveFunction { x in
            let period = 2.0 * .pi
            let t = x.truncatingRemainder(dividingBy: period)
            let normalizedT = t < 0 ? t + period : t
            
            var y = 0.0
            y += 0.15 * exp(-pow((normalizedT - 1.0) / 0.2, 2.0))
            y -= 0.15 * exp(-pow((normalizedT - 2.0) / 0.05, 2.0))
            y += 1.5 * exp(-pow((normalizedT - 2.2) / 0.1, 2.0))
            y -= 0.3 * exp(-pow((normalizedT - 2.4) / 0.05, 2.0))
            y += 0.25 * exp(-pow((normalizedT - 4.0) / 0.3, 2.0))
            return y
        }
    }
}

struct ECGStyleDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ECGStyleDemo()
        }
    }
}
