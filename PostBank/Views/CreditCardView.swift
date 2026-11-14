import SwiftUI

struct CreditCardView: View {
    private let grid: [(String, String, (String, Color)?)] = [
        ("list.bullet.rectangle", "账单分期", ("贴息", C.red)),
        ("yensign.circle", "找钱花", nil),
        ("crown", "我的权益", nil),
        ("creditcard", "积分专区", nil),
        ("rectangle.on.rectangle", "我的信用卡", nil)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                header
                banner
                greenCard
                newGuest
                gridCard
                promoThree
                Spacer(minLength: 24)
            }
        }
        .background(C.pageBg.ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
    }

    private var header: some View {
        VStack(spacing: 8) {
            Color.clear.frame(height: 54)
            HStack(spacing: 10) {
                HStack(spacing: 3) {
                    Image(systemName: "mappin.circle.fill").font(.system(size: 15))
                    Text("北京市").font(.system(size: 14))
                }
                .foregroundStyle(.white)
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 13)).foregroundStyle(C.textSecondary)
                    Text("账单分期").font(.system(size: 13)).foregroundStyle(C.textSecondary)
                    Spacer(minLength: 0)
                    Text("搜索").font(.system(size: 12, weight: .medium))
                        .foregroundStyle(C.textPrimary)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color(white: 0.95)))
                }
                .padding(.horizontal, 10).frame(height: 34)
                .background(Capsule().fill(.white))
                Circle().fill(.white.opacity(0.9)).frame(width: 32, height: 32)
                    .overlay(Image(systemName: "person.crop.circle")
                        .font(.system(size: 19)).foregroundStyle(C.textSecondary))
                Image(systemName: "rectangle.on.rectangle.angled")
                    .font(.system(size: 17)).foregroundStyle(.white)
            }
            .padding(.horizontal, M.hpad)
        }
        .background(LinearGradient(colors: [C.cardTop, C.cardMid],
                                   startPoint: .top, endPoint: .bottom))
    }

    private var banner: some View {
        ZStack(alignment: .topTrailing) {
            LinearGradient(colors: [C.cardMid, C.cardBot],
                           startPoint: .top, endPoint: .bottom)
            VStack(spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "e.circle.fill").font(.system(size: 14))
                    Text("中国邮政储蓄银行 | 信用卡").font(.system(size: 9, weight: .medium))
                    Image(systemName: "xmark").font(.system(size: 6))
                    Text("支付宝").font(.system(size: 9, weight: .medium))
                    Spacer()
                }
                .foregroundStyle(.white.opacity(0.9))
                .padding(.horizontal, M.hpad)
                .padding(.top, 6)

                Text("双11支付天天减")
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundStyle(.white)
                Text("单笔最高享11.11元立减")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12).padding(.vertical, 4)
                    .background(Capsule().fill(Color(red: 1.0, green: 0.45, blue: 0.15)))
                    .padding(.bottom, 14)
            }
            Text("广告")
                .font(.system(size: 9)).foregroundStyle(.white)
                .padding(.horizontal, 5).padding(.vertical, 2)
                .background(Capsule().fill(.black.opacity(0.2)))
                .padding(.trailing, 10).padding(.top, 30)
        }
    }

    private var greenCard: some View {
        VStack(spacing: 14) {
            Text("邮储小绿卡  省心又省钱")
                .font(.system(size: 21, weight: .bold))
                .foregroundStyle(Color(red: 0.85, green: 0.55, blue: 0.25))
            HStack(spacing: 14) {
                Text("查账"); Text("|").foregroundStyle(C.separator); Text("还款")
                Text("|").foregroundStyle(C.separator); Text("分期")
            }
            .font(.system(size: 14))
            .foregroundStyle(C.textSecondary)

            Text("添加信用卡")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(Capsule().fill(Color(red: 0.88, green: 0.65, blue: 0.42)))
                .padding(.horizontal, 60)
        }
        .padding(.vertical, 22)
        .background(C.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: M.cardRadius, style: .continuous))
        .padding(.horizontal, M.hpad)
        .offset(y: -18)
    }

    private var newGuest: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("新客专区")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(C.brandGreen)
                HStack(spacing: 6) {
                    Text("邮储信用卡新户专享权益")
                        .font(.system(size: 11)).foregroundStyle(C.brandGreen.opacity(0.75))
                    Text("去领取")
                        .font(.system(size: 10)).foregroundStyle(.white)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Capsule().fill(Color(red: 0.20, green: 0.72, blue: 0.62)))
                }
            }
            Spacer()
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 0.62, green: 0.90, blue: 0.75))
                .frame(width: 96, height: 64)
                .overlay(Image(systemName: "creditcard.fill")
                    .font(.system(size: 28)).foregroundStyle(.white))
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: M.cardRadius)
            .fill(Color(red: 0.90, green: 0.98, blue: 0.94)))
        .padding(.horizontal, M.hpad)
        .offset(y: -10)
    }

    private var gridCard: some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                ForEach(grid, id: \.1) { it in
                    GridItem(symbol: it.0, title: it.1, color: C.textPrimary,
                             badge: it.2.map { (text: $0.0, color: $0.1) })
                }
            }
            HStack(spacing: 5) {
                Capsule().fill(C.brandGreen).frame(width: 14, height: 3)
                Capsule().fill(C.separator).frame(width: 5, height: 3)
                Capsule().fill(C.separator).frame(width: 5, height: 3)
            }
        }
        .padding(.vertical, 16)
        .background(C.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: M.cardRadius, style: .continuous))
        .padding(.horizontal, M.hpad)
    }

    private var promoThree: some View {
        HStack(spacing: 8) {
            promoCard("周六5折", "最高25元代金券", Color(red: 1.0, green: 0.90, blue: 0.90))
            promoCard("超值优惠券", "去领取", Color(red: 1.0, green: 0.62, blue: 0.58), big: true)
            promoCard("周周享", "消费6天礼", Color(red: 1.0, green: 0.94, blue: 0.85))
        }
        .padding(.horizontal, M.hpad)
        .padding(.top, 12)
        .padding(.bottom, 12)
    }

    private func promoCard(_ t: String, _ s: String, _ bg: Color, big: Bool = false) -> some View {
        VStack(spacing: 5) {
            Text(t)
                .font(.system(size: big ? 15 : 14, weight: .bold))
                .foregroundStyle(big ? .white : C.red)
            Text(s)
                .font(.system(size: 9))
                .foregroundStyle(big ? .white.opacity(0.9) : C.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: big ? 86 : 76)
        .background(RoundedRectangle(cornerRadius: 10).fill(bg))
    }
}