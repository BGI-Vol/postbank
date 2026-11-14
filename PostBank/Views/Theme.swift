import SwiftUI

enum M {
    static let hpad: CGFloat = 16
    static let cardRadius: CGFloat = 14
    static let tabBarH: CGFloat = 52
    static let navH: CGFloat = 44
    static let searchH: CGFloat = 36
    static let iconD: CGFloat = 44
}

enum C {
    // 首页橙色活动区
    static let homeTop = Color(red: 1.00, green: 0.27, blue: 0.09)
    static let homeMid = Color(red: 1.00, green: 0.45, blue: 0.16)
    static let homeBot = Color(red: 1.00, green: 0.62, blue: 0.34)

    // 首页绿色版（图5）
    static let homeGreenTop = Color(red: 0.35, green: 0.72, blue: 0.90)
    static let homeGreenBot = Color(red: 0.78, green: 0.93, blue: 0.96)

    // 信用卡页蓝色
    static let cardTop = Color(red: 0.20, green: 0.47, blue: 0.85)
    static let cardMid = Color(red: 0.35, green: 0.62, blue: 0.92)
    static let cardBot = Color(red: 0.68, green: 0.85, blue: 0.97)

    // 财富页米色
    static let wealthTop = Color(red: 1.00, green: 0.96, blue: 0.89)
    static let wealthMid = Color(red: 0.99, green: 0.92, blue: 0.82)
    static let wealthBrown = Color(red: 0.35, green: 0.24, blue: 0.12)
    static let wealthGold = Color(red: 0.72, green: 0.55, blue: 0.25)

    static let brandGreen = Color(red: 0.00, green: 0.52, blue: 0.24)
    static let textPrimary = Color(red: 0.10, green: 0.10, blue: 0.11)
    static let textSecondary = Color(red: 0.45, green: 0.46, blue: 0.47)
    static let pageBg = Color(red: 0.96, green: 0.96, blue: 0.97)
    static let cardWhite = Color.white
    static let separator = Color(red: 0.92, green: 0.92, blue: 0.93)
    static let red = Color(red: 0.90, green: 0.16, blue: 0.14)
    static let gold = Color(red: 1.00, green: 0.78, blue: 0.20)

    // 金刚区图标色（截图取样）
    static let ic1 = Color(red: 0.42, green: 0.36, blue: 0.85)   // 充值-紫
    static let ic2 = Color(red: 1.00, green: 0.60, blue: 0.20)   // 缴费-橙
    static let ic3 = Color(red: 0.30, green: 0.56, blue: 0.90)   // 本地-蓝
    static let ic4 = Color(red: 0.20, green: 0.72, blue: 0.55)   // 政务-绿
    static let ic5 = Color(red: 1.00, green: 0.58, blue: 0.24)   // 活动-橙
    static let icGray = Color(red: 0.46, green: 0.48, blue: 0.50)
}

// MARK: - 通用

struct RCard<Content: View>: View {
    var radius: CGFloat = M.cardRadius
    var padding: CGFloat = 14
    @ViewBuilder var content: Content
    var body: some View {
        content
            .padding(padding)
            .background(RoundedRectangle(cornerRadius: radius, style: .continuous).fill(C.cardWhite))
    }
}

struct Badge: View {
    let text: String
    var bg: Color = C.red
    var fg: Color = .white
    var size: CGFloat = 9
    var body: some View {
        Text(text)
            .font(.system(size: size, weight: .medium))
            .foregroundStyle(fg)
            .padding(.horizontal, 4)
            .padding(.vertical, 1)
            .background(Capsule().fill(bg))
    }
}

/// 金刚区一项
struct GridItem: View {
    let symbol: String
    let title: String
    var color: Color = C.textPrimary
    var badge: (text: String, color: Color)? = nil
    var filled: Bool = false
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: symbol)
                        .font(.system(size: 26, weight: .regular))
                        .foregroundStyle(filled ? .white : color)
                        .frame(width: M.iconD, height: M.iconD)
                        .background(
                            Group {
                                if filled {
                                    Circle().fill(color)
                                } else {
                                    Color.clear
                                }
                            }
                        )
                    if let badge {
                        Badge(text: badge.text, bg: badge.color)
                            .offset(x: 14, y: -6)
                    }
                }
                Text(title)
                    .font(.system(size: 12))
                    .foregroundStyle(C.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

/// 顶部搜索条
struct TopSearchBar: View {
    var placeholder: String
    var leadingIcon: String = "magnifyingglass"
    var showLocation: Bool = false
    var location: String = "北京市"
    var onBack: (() -> Void)? = nil
    var trailing: AnyView? = nil

    var body: some View {
        HStack(spacing: 10) {
            if let onBack {
                Button(action: onBack) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 19, weight: .medium))
                        .foregroundStyle(C.textPrimary)
                }
                .buttonStyle(.plain)
            } else if showLocation {
                HStack(spacing: 3) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 16))
                    Text(location).font(.system(size: 15))
                }
                .foregroundStyle(C.textPrimary)
            } else {
                Image(systemName: "message")
                    .font(.system(size: 19))
                    .foregroundStyle(C.textPrimary)
            }

            HStack(spacing: 6) {
                Image(systemName: leadingIcon)
                    .font(.system(size: 13))
                    .foregroundStyle(C.textSecondary)
                Text(placeholder)
                    .font(.system(size: 13))
                    .foregroundStyle(C.textSecondary)
                    .lineLimit(1)
                Spacer(minLength: 0)
                Text("搜索")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(C.textPrimary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color(white: 0.95)))
            }
            .padding(.horizontal, 10)
            .frame(height: M.searchH)
            .background(Capsule().fill(.white))

            if let trailing { trailing } else {
                Circle()
                    .fill(Color(white: 0.97))
                    .frame(width: 34, height: 34)
                    .overlay(
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 20))
                            .foregroundStyle(C.textSecondary)
                    )
            }
        }
        .padding(.horizontal, M.hpad)
        .frame(height: M.navH)
    }
}