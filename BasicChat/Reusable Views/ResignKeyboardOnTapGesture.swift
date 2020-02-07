//
//  ResignKeyboardOnTapGesture.swift
//  BasicChat
//
//  Created by Tom Baranes on 19/12/2019.
//

import SwiftUI

struct ResignKeyboardOnTapGesture: ViewModifier {
    var gesture = TapGesture().onEnded {
        UIApplication.shared.endEditing(true)
    }

    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnTapGesture() -> some View {
        modifier(ResignKeyboardOnTapGesture())
    }
}
