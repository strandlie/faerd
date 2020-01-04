//
//  RadioPicker.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 23/12/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import SwiftUI

struct RadioPicker: View {
    let options: [FirstScreenSelection]
    @Binding var currentlySelected: FirstScreenSelection
    
    var body: some View {
        ForEach(options, id: \.self) { option in
            RadioOption(option: option, currentlySelected: self.$currentlySelected)
                
        }
    }
}

private struct RadioOption: View {
    let option: FirstScreenSelection
    @Binding var currentlySelected: FirstScreenSelection
    
    var body: some View {
        Button(action: {self.currentlySelected = self.option}) {
            HStack {
                Image(systemName: "checkmark")
                    .opacity(self.$currentlySelected.wrappedValue == self.option ? 1 : 0)
                    .accessibility(hidden: self.$currentlySelected.wrappedValue == self.option)
                    .colorMultiply(.green)
                Text(option.rawValue)
                    .padding(.leading, 5)
                Spacer()
            }
            
        }
        
    }
}

struct RadioPicker_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RadioPicker(options: [.favorites, .list], currentlySelected: .constant(.list))
        }
        
    }
}
