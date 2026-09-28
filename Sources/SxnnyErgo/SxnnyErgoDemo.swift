//
//  SxnnyErgoDemo.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 28/09/26.
//

import SwiftUI

// MARK: - SxnnyErgo Showcase Demo
//
// A single-screen demonstration showcasing SxnnyErgo's primary ergonomic APIs
// in a realistic UI without SwiftUI boilerplate:
//
//  1. @Adaptive                        — size-class adaptive metrics without #if or geometry checks
//  2. @FocusState ergonomics           — .focusOnAppear and .advancesFocusOnSubmit
//  3. Task ergonomics                  — .task(id:debounce:) for search/inputs
//  4. Layout containers                — FlowLayout for auto-wrapping tag chips
//  5. Numeric text animation           — AnimatedNumericText with zero transition glue code
//  6. Binding ergonomics               — $amount.double and $amount.clamped(to:)
//  7. Visual & interaction modifiers   — .shake(), .dismissesKeyboardOnTap(), .cardStyle()
//  8. Accessibility helpers            — .autoContrastForeground(on:) and .minimumTappableFrame()
//  9. Component styling                — .buttonStyle(.roundedProminent()) and .badge()

/// A concise, ready-to-screenshot showcase demonstrating SxnnyErgo's most impactful
/// ergonomic extensions and modifiers in a single real-world view.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@MainActor
public struct SxnnyErgoDemoView: View {

    private enum Field: Hashable, CaseIterable {
        case recipient
        case amount
        case note
    }

    // MARK: - State

    @Adaptive(compact: 16, regular: 28) private var cardPadding: CGFloat
    @FocusState private var focusedField: Field?

    @State private var recipient = ""
    @State private var amount = 250
    @State private var selectedCategory = "Design"
    @State private var isUrgent = true
    @State private var errorCount = 0

    private let categories = ["Engineering", "Design", "Marketing", "Research", "Ops"]
    private let brandColor = Color(hex: "#5B5CE6")

    // MARK: - Initializer

    /// Creates an instance of the SxnnyErgo showcase demo view.
    public init() {}

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 18) {

            // Header with Animated Counter & Badge Overlay
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Instant Transfer")
                        .font(.title2.bold())
                    Text("Available Balance: $")
                        .foregroundStyle(.secondary)
                        + Text("12,450.00")
                }
                Spacer()
                Image(systemName: "bell.badge.fill")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .badge(count: 3, color: .red)
                    .minimumTappableFrame()
            }

            // Live Numeric Total (Smooth Digit-by-Digit Animation)
            HStack(alignment: .firstTextBaseline) {
                Text("$")
                    .font(.title.bold())
                    .foregroundStyle(brandColor)
                AnimatedNumericText(value: amount, animation: .spring(response: 0.35, dampingFraction: 0.8))
                    .font(.system(size: 42, weight: .bold, design: .rounded))
            }

            // Input Fields with Programmatic Focus Chain & Shake Validation
            VStack(spacing: 12) {
                TextField("Recipient (@username)", text: $recipient)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .recipient)
                    .focusOnAppear($focusedField, equals: .recipient)
                    .advancesFocusOnSubmit($focusedField)
                    .task(id: recipient, debounce: .milliseconds(300)) {
                        // Debounced lookup automatically cancels rapid typing
                    }

                // Int -> Double Binding Projection + Range Clamping
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Amount Limit")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("$\(amount)")
                            .font(.caption.monospacedDigit())
                    }
                    Slider(value: $amount.clamped(to: 10...1000).double, in: 10...1000, step: 10)
                }
            }
            .shake(trigger: errorCount)

            // FlowLayout: Fluid Wrapping Tag Chips with Auto-Contrasting Text
            Text("Category")
                .font(.caption)
                .foregroundStyle(.secondary)

            FlowLayout(horizontalSpacing: 8, verticalSpacing: 8) {
                ForEach(categories, id: \.self) { category in
                    let isSelected = selectedCategory == category
                    let bg = isSelected ? brandColor : Color(light: Color(white: 0.92), dark: Color(white: 0.2))

                    Text(category)
                        .font(.subheadline.weight(.medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(bg)
                        .clipShape(Capsule())
                        .autoContrastForeground(on: bg)
                        .onTapGesture { selectedCategory = category }
                }
            }

            // Action Button with Prominent Style & Conditional Transform
            Button(action: handleTransfer) {
                Label("Confirm Transfer", systemImage: "arrow.up.right.circle.fill")
                    .font(.headline)
            }
            .buttonStyle(.roundedProminent(backgroundColor: brandColor, cornerRadius: 14))
            .if(isUrgent) {
                $0.overlay(alignment: .topTrailing) {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 10, height: 10)
                        .offset(x: -6, y: 6)
                }
            }
        }
        .padding(cardPadding)
        .cardStyle(cornerRadius: 20, shadowRadius: 10)
        .dismissesKeyboardOnTap()
        .frame(maxWidth: 480)
    }

    private func handleTransfer() {
        if recipient.trimmingCharacters(in: .whitespaces).isEmpty {
            errorCount += 1
        }
    }
}

// MARK: - Preview

#Preview("SxnnyErgo Showcase") {
    if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
        ZStack {
            Color(light: Color(white: 0.96), dark: Color(white: 0.1))
                .ignoresSafeArea()
            SxnnyErgoDemoView()
                .padding()
        }
    }
}
