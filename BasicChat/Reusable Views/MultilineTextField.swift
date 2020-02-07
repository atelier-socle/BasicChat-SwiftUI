//
//  MultilineTextField.swift
//  BasicChat
//
//  Created by Tom Baranes on 07/02/2020.
//  Copyright © 2020 tbaranes. All rights reserved.
//
// Highly inspired from: https://stackoverflow.com/a/57853937/4177109
//

import SwiftUI
import UIKit

struct MultilineTextField: View {
    private let geometry: GeometryProxy
    private let placeholder: String
    private let onCommit: (() -> Void)?
    private let onValueChanged: (() -> Void)?

    @State private var dynamicHeight: CGFloat = 100
    @State private var showingPlaceholder = false
    @Binding private var text: String

    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.showingPlaceholder = $0.isEmpty
        }
    }

    init(_ placeholder: String = "", text: Binding<String>, geometry: GeometryProxy, onCommit: (() -> Void)? = nil, onValueChanged: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self.onValueChanged = onValueChanged
        self.geometry = geometry
        self._text = text
        self._showingPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }

    var body: some View {
        UITextViewWrapper(text: self.internalText, calculatedHeight: $dynamicHeight, geometry: geometry, onDone: onCommit, onValueChanged: onValueChanged)
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
            .overlay(placeholderView, alignment: .topLeading)
    }

    var placeholderView: some View {
        Group {
            if showingPlaceholder {
                Text(placeholder).foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
    }
}

private struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    @Binding var calculatedHeight: CGFloat

    let geometry: GeometryProxy
    let onDone: (() -> Void)?
    let onValueChanged: (() -> Void)?

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator

        textField.isEditable = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        if onDone != nil {
            textField.returnKeyType = .done
        }

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        recalculateHeight(view: uiView, result: $calculatedHeight)
    }

    func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = min(self.geometry.size.height / 2, newSize.height) // !! must be called asynchronously
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, text: $text, height: $calculatedHeight, onDone: onDone, onValueChanged: onValueChanged)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var parent: UITextViewWrapper
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?
        var onValueChanged: (() -> Void)?

        init(parent: UITextViewWrapper, text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)?, onValueChanged: (() -> Void)?) {
            self.parent = parent
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
            self.onValueChanged = onValueChanged
        }

        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            onValueChanged?()
            parent.recalculateHeight(view: uiView, result: calculatedHeight)
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            guard let onDone = self.onDone, text == "\n" else {
                return true
            }

            textView.resignFirstResponder()
            onDone()
            return false
        }
    }

}
