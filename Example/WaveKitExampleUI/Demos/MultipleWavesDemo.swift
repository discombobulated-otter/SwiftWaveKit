import SwiftUI
import WaveKit

struct MultipleWavesDemo: View {
    @State private var amplitude: Double = 1.0
    @State private var frequency1: Double = 1.5
    @State private var frequency2: Double = 3.0
    @State private var isAnimated: Bool = true
    @State private var isPureTone: Bool = false
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
                    
                    let combined = isPureTone ? 
                        WaveFunction.sine(frequency: frequency1) :
                        (WaveFunction.sine(frequency: frequency1) + WaveFunction.cosine(frequency: frequency2)) * 0.6
                    
                    WaveView(combined)
                        .amplitude(amplitude)
                        .waveColor(.white)
                        .animated(isAnimated)
                        .renderMode3D(true)
                        .showGrid(showGrid)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                }
                .frame(height: 280)
                .padding(.horizontal, 20)
                
                VStack(spacing: 24) {
                    DemoSlider(title: "Amplitude", value: $amplitude, range: 0.1...2.5, format: "%.2f")
                    DemoSlider(title: "Frequency 1", value: $frequency1, range: 0.5...5.0, format: "%.1f")
                    
                    if !isPureTone {
                        DemoSlider(title: "Frequency 2", value: $frequency2, range: 0.5...5.0, format: "%.1f")
                    }
                    
                    HStack(spacing: 30) {
                        Toggle(isOn: $isPureTone) {
                            Text("Pure")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        
                        Toggle(isOn: $isAnimated) {
                            Text("Animate")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        
                        Toggle(isOn: $showGrid) {
                            Text("Grid")
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

struct MultipleWavesDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MultipleWavesDemo()
        }
    }
}
