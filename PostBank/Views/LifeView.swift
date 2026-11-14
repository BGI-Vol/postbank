import SwiftUI

struct LifeView: View {
    @State private var seg = 0

    private let grid1: [(String, String, Color, (String, Color)?)] = [
        ("creditcard.fill", "充值特惠", C.ic1, ("充值·省", C.red)),
        ("bolt.fill", "生活缴费", C.ic2, nil),
        ("mappin.circle.fill", "本地服务", C.ic3, nil),
        ("building.columns.fill", "政务便民", C.ic4, nil),
        ("gift.fill", "活动专区", C.ic5, nil)
    ]
    private let grid2: [(String, String, Color, (String, Color)?)] = [
        ("envelope.fill", "中国集邮", C.ic1, ("邮票金", C.red)),
        ("film.fill", "电影票", C.ic2, nil),
        ("bag.fill", "邮乐商城", C.ic4, nil),
        ("shippingbox.fill", "快递服务", C.ic4, nil),
        ("square.grid.2x2.fill", "更多", C.icGray, nil)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                header
                banner
                gridCard
                segmented
                twoColumn
                mediaSection
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
                    Text("马上充，马上省！").font(.system(size: 13)).foregroundStyle(C.textSecondary)
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
            }
            .padding(.horizontal, M.hpad)
        }
        .background(LinearGradient(colors: [C.homeTop, C.homeMid],
                                   startPoint: .top, endPoint: .bottom))
    }

    private var banner: some View {
        ZStack(alignment: .topTrailing) {
            LinearGradient(colors: [C.homeMid, C.homeBot],
                           startPoint: .top, endPoint: .bottom)
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 5) {
                    Image(systemName: "e.circle.fill").font(.system(size: 13))
                    Text("中国邮政储蓄银行").font(.system(size: 9, weight: .medium))
                    Spacer()
                }
                .foregroundStyle(.white)

                Text("马上充，马上省")
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundStyle(
                        LinearGradient(colors: [.white, Color(red: 1.0, green: 0.94, blue: 0.60)],
                                       startPoint: .top, endPoint: .bottom)
                    )
                Text("低至 1 元")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(C.red)
                    .padding(.horizontal, 12).padding(.vertical, 4)
                    .background(Capsule().fill(Color(red: 1.0, green: 0.88, blue: 0.35)))
                Text("本优惠由易百信息技术（上海）股份有限公司提供，客服热线：4008211400")
                    .font(.system(size: 7))
                    .foregroundStyle(.white.opacity(0.85))
                    .padding(.top, 2)
            }
            .padding(.horizontal, M.hpad)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)

            Text("广告")
                .font(.system(size: 9)).foregroundStyle(.white)
                .padding(.horizontal, 5).padding(.vertical, 2)
                .background(Capsule().fill(.black.opacity(0.2)))
                .padding(.trailing, 10).padding(.top, 8)
        }
    }

    private var gridCard: some View {
        VStack(spacing: 14) {
            HStack(spacing: 0) {
                ForEach(grid1, id: \.1) { it in
                    GridItem(symbol: it.0, title: it.1, color: it.2,
                             badge: it.3.map { (text: $0.0, color: $0.1) })
                }
            }
            HStack(spacing: 0) {
                ForEach(grid2, id: \.1) { it in
                    GridItem(symbol: it.0, title: it.1, color: it.2,
                             badge: it.3.map { (text: $0.0, color: $0.1) })
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
        .offset(y: -8)
    }

    private var segmented: some View {
        HStack(spacing: 26) {
            ForEach(Array(["精选", "本地", "热门活动", "发现"].enumerated()), id: \.offset) { i, t in
                VStack(spacing: 5) {
                    Text(t)
                        .font(.system(size: i == seg ? 19 : 17, weight: i == seg ? .bold : .regular))
                        .foregroundStyle(i == seg ? C.textPrimary : C.textSecondary)
                    Capsule()
                        .fill(i == seg ? C.brandGreen : .clear)
                        .frame(width: 22, height: 3)
                }
                .onTapGesture { seg = i }
            }
            Spacer()
        }
        .padding(.horizontal, M.hpad)
        .padding(.bottom, 10)
    }

    private var twoColumn: some View {
        HStack(alignment: .top, spacing: 10) {
            // 左：美团大卡
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    LinearGradient(colors: [Color(red: 1.0, green: 0.84, blue: 0.20),
                                            Color(red: 1.0, green: 0.76, blue: 0.10)],
                                   startPoint: .top, endPoint: .bottom)
                    VStack(spacing: 6) {
                        Text("8.5折起")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundStyle(C.red)
                        Text("买美团外卖红包")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(C.red)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white.opacity(0.55))
                            .frame(height: 96)
                            .overlay(Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                                .font(.system(size: 38))
                                .foregroundStyle(C.red.opacity(0.55)))
                            .padding(.top, 4)
                        Text("立享优惠")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(C.red))
                            .padding(.top, 4)
                    }
                    .padding(12)
                    Text("广告").font(.system(size: 8)).foregroundStyle(C.textSecondary)
                        .padding(5)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))

            // 右：精彩推荐
            VStack(alignment: .leading, spacing: 10) {
                Text("精彩推荐")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(C.red)

                recommendRow("book.pages.fill", "报刊订阅", "精选即订",
                             Color(red: 0.70, green: 0.80, blue: 0.95))
                recommendRow("cup.and.saucer.fill", "古茗", "9.3折",
                             Color(red: 0.95, green: 0.85, blue: 0.72))
                recommendRow("books.vertical.fill", "樊登课程", "樊登讲《论语》",
                             Color(red: 0.95, green: 0.88, blue: 0.78))
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 1.0, green: 0.94, blue: 0.94)))
        }
        .padding(.horizontal, M.hpad)
    }

    private func recommendRow(_ icon: String, _ title: String, _ sub: String, _ bg: Color) -> some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(bg)
                .frame(width: 42, height: 42)
                .overlay(Image(systemName: icon)
                    .font(.system(size: 18)).foregroundStyle(.white))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 13, weight: .medium)).foregroundStyle(C.textPrimary)
                Text(sub).font(.system(size: 11)).foregroundStyle(C.textSecondary)
            }
            Spacer(minLength: 0)
        }
    }

    private var mediaSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("影音娱乐")
                    .font(.system(size: 19, weight: .bold))
                    .foregroundStyle(C.textPrimary)
                Spacer()
                Image(systemName: "ellipsis").foregroundStyle(C.textSecondary)
            }
            .padding(.horizontal, M.hpad)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    mediaCard("喜马拉雅", "低至6.5折", Color(red: 0.98, green: 0.95, blue: 0.90))
                    mediaCard("神探之痕迹", "新客畅听", Color(red: 0.90, green: 0.93, blue: 0.97))
                    mediaCard("樊登读书", "7天体验", Color(red: 0.93, green: 0.96, blue: 0.90))
                }
                .padding(.horizontal, M.hpad)
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 12)
    }

    private func mediaCard(_ t: String, _ s: String, _ bg: Color) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(t).font(.system(size: 14, weight: .semibold)).foregroundStyle(C.textPrimary)
            Text(s).font(.system(size: 11)).foregroundStyle(C.textSecondary)
            Spacer(minLength: 0)
        }
        .frame(width: 160, height: 76, alignment: .topLeading)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 10).fill(bg))
    }
}