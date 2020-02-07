//
//  KeyboardResponder.swift
//  BasicChat
//
//  Created by Tom Baranes on 19/12/2019.
//

import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {

    // MARK: Properties

    @Published var currentHeight: CGFloat = 0

    private let willset = PassthroughSubject<CGFloat, Never>()
    private var keyboardDuration: TimeInterval = 0
    private var _center: NotificationCenter

    // MARK: Life Cycle

    init(center: NotificationCenter = .default) {
        _center = center
        _center.addObserver(self,
                            selector: #selector(keyBoardWillShow(notification:)),
                            name: UIResponder.keyboardWillShowNotification,
                            object: nil)
        _center.addObserver(self,
                            selector: #selector(keyBoardWillHide(notification:)),
                            name: UIResponder.keyboardWillHideNotification,
                            object: nil)
    }

    deinit {
        _center.removeObserver(self)
    }

}

// MARK: - Notifications

extension KeyboardResponder {

    @objc
    func keyBoardWillShow(notification: Notification) {
        let notifSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let notifDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let keyboardSize = notifSize, let duration = notifDuration else {
            return
        }

        keyboardDuration = duration
        withAnimation(.easeInOut(duration: duration)) {
            self.currentHeight = keyboardSize.height
        }
    }

    @objc
    func keyBoardWillHide(notification: Notification) {
        let notifDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let duration = notifDuration else {
            return
        }

        withAnimation(.easeInOut(duration: duration)) {
            currentHeight = 0
        }
    }

}
