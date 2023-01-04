//
//  SettingsView.swift
//  Notes WatchKit Extension
//
//  Created by Ashish Sharma on 01/04/2023.
//

import SwiftUI

struct SettingsView: View {
    //MARK: - PROPERTIES
    
    @AppStorage("lineCount") var lineCount: Int = 1
    @State private var value: Float = 1.0
    
    //MARK: FUNCTIONS
    func update() {
        lineCount = Int(value)
    }
    
    //MARK: - BODY
    
    var body: some View {
        VStack(spacing: 8) {
            //HEADER
            HeaderView(title: "Settings")
            
            //ACTUAL LINE COUNT
            Text("Lines: \(lineCount)".uppercased())
                .fontWeight(.bold)
            
            //SLIDER
            Slider(value: Binding(get: {self.value}, set: { newValue in    // without curly braces the self.value part gives error
                self.value = newValue
                self.update()
            })
                    , in: 1...5, step: 1)
                .accentColor(.accentColor)
            
        } //: VSTACK
    } //: BODY
}


//MARK: - PREVIEW

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
