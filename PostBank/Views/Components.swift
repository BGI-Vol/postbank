import SwiftUI

// MARK: - 主按钮（登录页用）
struct PrimaryButton: View {
    let title: String
    var enabled: Bool = true
    var loading: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .opacity(loading ? 0 : 1)
                if loading { ProgressView().tint(.white) }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(enabled ? C.brandGreen : C.brandGreen.opacity(0.35))
            )
            .foregroundStyle(.white)
        }
        .disabled(!enabled || loading)
        .buttonStyle(.plain)
    }
}

// MARK: - 输入行（登录页用）
struct FieldRow: View {
    let title: String
    @Binding var text: String
    var placeholder: String = ""
    var keyboard: UIKeyboardType = .default
    var isSecure: Bool = false
    var trailing: AnyView? = nil

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 15))
                    .foregroundStyle(C.textPrimary)
                    .frame(width: 76, alignment: .leading)

                Group {
                    if isSecure { SecureField(placeholder, text: $text) }
                    else { TextField(placeholder, text: $text) }
                }
                .font(.system(size: 16))
                .keyboardType(keyboard)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

                if let trailing { trailing }
            }
            .padding(.horizontal, 18)
            .frame(height: 54)

            Rectangle()
                .fill(C.separator)
                .frame(height: 0.5)
                .padding(.leading, 18)
        }
    }
}

// MARK: - 错误条（登录页用）
struct ErrorBanner: View {
    let message: String
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.circle.fill")
            Text(message).font(.system(size: 13))
            Spacer(minLength: 0)
        }
        .foregroundStyle(C.red)
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .background(RoundedRectangle(cornerRadius: 10).fill(C.red.opacity(0.08)))
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
}

// MARK: - 交易行
struct TransactionRow: View {
    let tx: Transaction
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(C.brandGreen.opacity(0.10)).frame(width: 40, height: 40)
                Image(systemName: tx.direction == .income ? "arrow.down.left" : "arrow.up.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(C.brandGreen)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(tx.counterparty)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(C.textPrimary).lineLimit(1)
                Text(tx.title + " · " + tx.dateText)
                    .font(.system(size: 12))
                    .foregroundStyle(C.textSecondary).lineLimit(1)
            }
            Spacer(minLength: 8)
            Text(tx.amountText)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(tx.direction == .income ? C.red : C.textPrimary)
        }
        .padding(.vertical, 12)
    }
}

extension View {
    func hideKeyboardOnTap() -> some View {
        onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}