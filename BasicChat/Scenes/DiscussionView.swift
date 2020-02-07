//
//  ContentView.swift
//  BasicChat
//
//  Created by Tom Baranes on 07/02/2020.
//  Copyright © 2020 tbaranes. All rights reserved.
//

import SwiftUI

struct DiscussionView: View {
    @State var messages = FakeDatabase.messages
    @State var composedMessage = ""
    @State var isSendEnabled: Bool = false

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    ScrollView {
                        ForEach(self.messages) {
                            MessageView(geometry: geometry,
                                        isFirst: $0.id == self.messages.first?.id, message: $0,
                                        fromMe: $0.user.id == FakeDatabase.me.id)
                        }
                    }.resignKeyboardOnDragGesture()
                        .resignKeyboardOnTapGesture()
                    FieldView(composedMessage: self.$composedMessage, isSendEnabled: self.$isSendEnabled, geometry: geometry, sendMessage: self.sendMessage)
                }
            }.navigationBarTitle("Discussion", displayMode: .inline)
        }.onDisappear() {
            FakeDatabase.messages = self.messages
        }
    }

    private func sendMessage() {
        guard !composedMessage.isEmpty else {
            return
        }

        messages.append(Message(user: FakeDatabase.me, text: composedMessage, date: Date()))
        composedMessage = ""
        isSendEnabled = false
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.messages.append(Message(user: FakeDatabase.users.randomElement()!, text: "Quick answer to you", date: Date()))
        }
    }

}

private struct FieldView: View {
    @Binding var composedMessage: String
    @Binding var isSendEnabled: Bool
    @ObservedObject var keyboard = KeyboardResponder()

    let geometry: GeometryProxy
    var sendMessage: () -> Void

    var body: some View {
        MultilineTextField("Message...", text: self.$composedMessage, geometry: geometry, onValueChanged:  {
            self.isSendEnabled = !self.composedMessage.isEmpty
        }).padding(.trailing, 20)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.primary))
            .overlay(SendButtonView(isEnabled: $isSendEnabled, sendMessage: sendMessage))
            .padding(.horizontal)
            .padding(.bottom, max(10, self.keyboard.currentHeight - geometry.safeAreaInsets.bottom + 10))
    }
}

private struct SendButtonView: View {
    @Binding var isEnabled: Bool
    var sendMessage: () -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                }.disabled(!isEnabled)
                    .foregroundColor(isEnabled ? Color.blue : .gray)
                    .resignKeyboardOnTapGesture()

            }.padding(.horizontal, 10)
        }.padding(.bottom, 12)
    }
}

private struct MessageView: View {
    let geometry: GeometryProxy
    let isFirst: Bool
    let message: Message
    let fromMe: Bool

    var body: some View {
        HStack(alignment: .bottom) {
            if !fromMe {
                Image(message.user.imageProfile).resizable().frame(width: 40, height: 40).clipShape(Circle())
            } else {
                Spacer()
            }

            Text(message.text)
                .font(.footnote)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color(message.user.colorName))
                .cornerRadius(10)
                .padding(.vertical, 1)
                .padding(fromMe ? .leading : .trailing, geometry.size.width / 5)

            if !fromMe {
                Spacer()
            }
        }.padding(.horizontal)
            .padding(.vertical, isFirst ? 5 : 0)
    }
}

struct DiscussionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DiscussionView().environment(\.colorScheme, .dark)
            DiscussionView().environment(\.colorScheme, .light)
        }
    }
}
