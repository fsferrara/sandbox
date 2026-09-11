//
//  ContentView.swift
//  TuistTuistTuttoMondo
//
//  Created by Saverio Ferrara on 9/11/26.
//

import SwiftUI
import GreetingKit

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(Greeting.message)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
