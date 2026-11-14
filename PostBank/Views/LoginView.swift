import SwiftUI

struct LoginView: View {
    @Environment(AppStore.self) private var store

    @State private var cardNo = ""
    @State private var password = ""
    @State private var smsCode = ""
    @State private var countdown = 0
    @State private var timer: Timer?

    private var canSubmit: Bool {
        cardNo.filter(\.isNumber).count >= 16
            && password.count >= 6
            && smsCode.filter(\.isNumber).count == 6
            && !store.loginState.isLoading
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                header

                VStack(spacing: 0) {
                    FieldRow(title: "卡号/账号",
                             text: $cardNo,
                             placeholder: "请输入 16 位卡号",
                             keyboard: .numberPad)
                        .onChange(of: cardNo) { _, v in
                            cardNo = Self.formatCardNo(v)
                        }

                    FieldRow(title: "登录密码",
                             text: $password,
                             placeholder: "请输入登录密码",
                             isSecure: true)

                    FieldRow(
                        title: "验证码",
                        text: $smsCode,
                        placeholder: "6 位短信验证码",
                        keyboard: .numberPad,
                        trailing: AnyView(smsButton)
                    )
                    .onChange(of: smsCode) { _, v in
                        smsCode = String(v.filter(\.isNumber).prefix(6))
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(C.cardWhite)
                )
                .padding(.horizontal, 16)
                .padding(.top, 28)

                if case .failure(let msg) = store.loginState {
                    ErrorBanner(message: msg)
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                }

                PrimaryButton(
                    title: "登 录",
                    enabled: canSubmit,
                    loading: store.loginState.isLoading
                ) {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    Task {
                        await store.login(cardNo: cardNo, password: password, smsCode: smsCode)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)

                VStack(spacing: 10) {
                    HStack(spacing: 18) {
                        Text("忘记密码").onTapGesture {}
                        Text("注册").onTapGesture {}
                        Text("安全中心").onTapGesture {}
                    }
                    .font(.system(size: 13))
                    .foregroundStyle(C.textSecondary)

                    Text("本 App 为本地界面仿真，不含任何真实账户或联网请求")
                        .font(.system(size: 11))
                        .foregroundStyle(C.textSecondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.top, 6)
                }
                .padding(.top, 22)
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 40)
        }
        .background(C.pageBg.ignoresSafeArea())
        .hideKeyboardOnTap()
        .onDisappear { timer?.invalidate() }
    }

    private var header: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(C.brandGreen)
                    .frame(width: 64, height: 64)
                Image(systemName: "building.columns.fill")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .padding(.top, 56)

            Text("手机银行")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(C.textPrimary)

            Text("安全 · 便捷 · 随身")
                .font(.system(size: 12))
                .foregroundStyle(C.textSecondary)
        }
    }

    private var smsButton: some View {
        Button {
            guard countdown == 0 else { return }
            countdown = 60
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                Task { @MainActor in
                    if countdown > 0 {
                        countdown -= 1
                    } else {
                        timer?.invalidate()
                    }
                }
            }
        } label: {
            Text(countdown > 0 ? "\(countdown)s" : "获取验证码")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(countdown > 0 ? C.textSecondary : C.brandGreen)
                .frame(width: 84, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(countdown > 0 ? C.separator : C.brandGreen, lineWidth: 0.8)
                )
        }
        .buttonStyle(.plain)
    }

    /// 每 4 位插入空格
    static func formatCardNo(_ raw: String) -> String {
        let digits = raw.filter(\.isNumber)
        let limited = String(digits.prefix(19))
        var out = ""
        for (i, ch) in limited.enumerated() {
            if i > 0 && i % 4 == 0 { out.append(" ") }
            out.append(ch)
        }
        return out
    }
}