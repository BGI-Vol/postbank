import SwiftUI

/// 长按 1.5 秒弹出输入框，改完立即生效并持久化。
/// 用在「我的·我的资产」和「财富·总资产」两处，共享 AppStore.accounts[0].balance。
struct EditableAmount: View {
    let amount: Decimal
    var prefix: String = "¥"
    var fontSize: CGFloat = 34
    var weight: Font.Weight = .bold

    @State private var editing = false
    @State private var draft = ""

    private var display: String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f.string(from: amount as NSDecimalNumber) ?? "0.00"
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 2) {
            Text(prefix)
                .font(.system(size: fontSize * 0.62, weight: weight))
            Text(display)
                .font(.system(size: fontSize, weight: weight, design: .rounded))
                .contentTransition(.numericText())
        }
        .foregroundStyle(C.textPrimary)
        .animation(.snappy, value: amount)
        .onLongPressGesture(minimumDuration: 1.5) {
            draft = "\(amount)"
            editing = true
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        .alert("修改余额", isPresented: $editing) {
            TextField("金额", text: $draft)
                .keyboardType(.decimalPad)
            Button("确定") {
                let cleaned = draft.replacingOccurrences(of: ",", with: "")
                if let d = Decimal(string: cleaned), d >= 0 {
                    AppStore.shared.updateBalance(d)
                }
            }
            Button("取消", role: .cancel) {}
        } message: {
            Text("仅修改本机显示，不涉及任何真实账户")
        }
    }
}