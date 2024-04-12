//
//  KeyboardHeightListenerModifier.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/11/24.
//
//  Move TextField up when the keyboard has appeared in SwiftUI:
//  https://stackoverflow.com/a/60178361

import Combine
import SwiftUI

struct KeyboardHeightListenerModifier: ViewModifier {
    @Binding var value: CGFloat
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                NotificationCenter.Publisher(
                    center: NotificationCenter.default,
                    name: UIResponder.keyboardWillShowNotification
                )
                .merge(with: NotificationCenter.Publisher(
                    center: NotificationCenter.default,
                    name: UIResponder.keyboardWillChangeFrameNotification
                ))
                .compactMap { notification in
                    notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                }
                .map { rect in
                    rect.height
                }
                .subscribe(Subscribers.Assign(object: self, keyPath: \.value))
                
                NotificationCenter.Publisher(
                    center: NotificationCenter.default,
                    name: UIResponder.keyboardWillHideNotification
                )
                .compactMap { _ in
                    CGFloat.zero
                }
                .subscribe(Subscribers.Assign(object: self, keyPath: \.value))
            }
    }
}

extension View {
    func keyboardHeightListener(value: Binding<CGFloat>) -> some View {
        return modifier(KeyboardHeightListenerModifier(value: value))
    }
}
