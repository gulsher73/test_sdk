//
//  ContentView.swift
//  ExampleIOS
//
//  Created by Gulsher on 10/03/26.
//

import SwiftUI
import TestFlutterSDK

struct ContentView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text("Example Host App")
                .font(.title2)
                .fontWeight(.semibold)

            Button(action: openFlutterScreen) {
                Text("Open Flutter Hello World")
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 32)
        }
        .padding()
    }

    private func openFlutterScreen() {
        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController else { return }
        TestSDK.showHelloWorld(from: rootVC)
    }
}

#Preview {
    ContentView()
}
