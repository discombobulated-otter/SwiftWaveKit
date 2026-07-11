import SwiftUI
import Combine
import WaveKit

struct LoadingIndicatorDemo: View {
    @State private var isSpinning: Bool = false
    @State private var scale: CGFloat = 1.0
    
    // We will automatically pulse the amplitude using a timer
    @State private var amplitude: Double = 1.0
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.08, green: 0.08, blue: 0.18), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                VStack(spacing: 8) {
                    Text("3D Loading Indicators")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Micro-animations and rhythmic frequency pulses")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                // Spinner View using WaveView + modifiers
                VStack(spacing: 30) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color.white.opacity(0.04))
                            .overlay(
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                        
                        WaveView(.sine)
                            .waveform(amplitude: amplitude, frequency: 4.0)
                            .waveStyle(WaveStyle(color: .cyan))
                            .animated(speed: 1.0)
                            .gridStyle(.init(lineCount: 0))
                            .dropLineStyle(.init(lineCount: 0))
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .scaleEffect(scale)
                    }
                    .frame(width: 220, height: 220)
                    .rotationEffect(Angle(degrees: isSpinning ? 360 : 0))
                    
                    Text("Loading Asset Data...")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.cyan)
                }
                
                CodeSnippetView(code: """
                WaveView(.sine)
                    .waveform(
                        amplitude: self.amplitude, 
                        frequency: 4.0
                    )
                    .waveStyle(WaveStyle(color: .cyan))
                    .animated(speed: 1.0)
                    .gridStyle(.init(lineCount: 0))
                    .dropLineStyle(.init(lineCount: 0))
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .scaleEffect(scale)
                """)
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(timer) { time in
            let factor = sin(time.timeIntervalSince1970 * 2.0 * 1.5)
            amplitude = 1.0 + factor * 0.6
        }
        .onAppear {
            withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
                isSpinning = true
            }
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                scale = 1.2
            }
        }
    }
}

struct LoadingIndicatorDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoadingIndicatorDemo()
        }
    }
}
