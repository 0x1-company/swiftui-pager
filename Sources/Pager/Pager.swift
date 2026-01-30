import SwiftUI

// MARK: - Page

public struct Page<Content: View, Label: View> {
  let content: Content
  let label: Label

  public init(
    @ViewBuilder content: () -> Content,
    @ViewBuilder label: () -> Label,
  ) {
    self.content = content()
    self.label = label()
  }
}

// MARK: - AnyPage

public struct AnyPage: Identifiable {
  public let id: Int
  let content: AnyView
  let label: AnyView

  fileprivate init(id: Int, content: AnyView, label: AnyView) {
    self.id = id
    self.content = content
    self.label = label
  }
}

// MARK: - PageBuilder

@resultBuilder
public struct PageBuilder {
  public static func buildExpression(_ page: Page<some View, some View>) -> [AnyPage] {
    [AnyPage(id: 0, content: AnyView(page.content), label: AnyView(page.label))]
  }

  public static func buildBlock(_ components: [AnyPage]...) -> [AnyPage] {
    components.flatMap(\.self).enumerated().map { index, page in
      AnyPage(id: index, content: page.content, label: page.label)
    }
  }

  public static func buildOptional(_ component: [AnyPage]?) -> [AnyPage] {
    component ?? []
  }

  public static func buildEither(first component: [AnyPage]) -> [AnyPage] {
    component
  }

  public static func buildEither(second component: [AnyPage]) -> [AnyPage] {
    component
  }
}

// MARK: - PagerView

public struct PagerView: View {
  private let pages: [AnyPage]
  @State private var selection: Int = 0

  public init(@PageBuilder content: () -> [AnyPage]) {
    pages = content()
  }

  public var body: some View {
    contentView()
      .safeAreaInset(edge: .top, spacing: 0) {
        VStack(spacing: 0) {
          tabsView()
          dividerView()
        }
      }
      .animation(.easeInOut(duration: 0.2), value: selection)
  }

  @ViewBuilder
  private func tabsView() -> some View {
    HStack(spacing: 4) {
      ForEach(pages) { page in
        Button {
          selection = page.id
        } label: {
          page.label
            .foregroundStyle(Color.primary)
        }
        .frame(height: 44)
        .frame(maxWidth: .infinity)
      }
    }
  }

  @ViewBuilder
  private func dividerView() -> some View {
    VStack(spacing: 0) {
      GeometryReader { proxy in
        let count = CGFloat(pages.count)
        let tabWidth = proxy.size.width / count

        RoundedRectangle(cornerRadius: 2)
          .fill(Color.accentColor)
          .frame(width: tabWidth, height: 4)
          .offset(x: tabWidth * CGFloat(selection))
      }
      .frame(height: 4)

      Divider()
    }
  }

  @ViewBuilder
  private func contentView() -> some View {
    TabView(selection: $selection) {
      ForEach(pages) { page in
        page.content
          .tag(page.id)
      }
    }
    .frame(maxHeight: .infinity)
    .tabViewStyle(.page(indexDisplayMode: .never))
  }
}

#Preview {
  PagerView {
    Page {
      Text("Home")
    } label: {
      Text("Home")
    }

    Page {
      Text("Search")
    } label: {
      Text("Search")
    }

    Page {
      Text("Account")
    } label: {
      Text("Account")
    }
  }
}
