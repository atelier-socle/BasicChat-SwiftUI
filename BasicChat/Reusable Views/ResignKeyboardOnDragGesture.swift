//
//  ResignKeyboardOnDragGesture.swift
//  BasicChat
//
//  Created by Tom Baranes on 19/12/2019.
//

import SwiftUI

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged { _ in
        UIApplication.shared.endEditing(true)
    }

    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        modifier(ResignKeyboardOnDragGesture())
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        windows.first { $0.isKeyWindow }?.endEditing(force)
    }
}
