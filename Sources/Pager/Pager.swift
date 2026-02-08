import SwiftUI

// MARK: - Page

public struct Page<Selection: Hashable, Content: View, Label: View> {
  let id: Selection
  let content: Content
  let label: Label

  public init(
    id: Selection,
    @ViewBuilder content: () -> Content,
    @ViewBuilder label: () -> Label
  ) {
    self.id = id
    self.content = content()
    self.label = label()
  }
}

extension Page where Selection == Int {
  public init(
    @ViewBuilder content: () -> Content,
    @ViewBuilder label: () -> Label
  ) {
    self.id = 0
    self.content = content()
    self.label = label()
  }
}

// MARK: - AnyPage

public struct AnyPage<Selection: Hashable>: Identifiable {
  public let id: Selection
  let content: AnyView
  let label: AnyView

  fileprivate init(id: Selection, content: AnyView, label: AnyView) {
    self.id = id
    self.content = content
    self.label = label
  }
}

// MARK: - PageBuilder

@resultBuilder
public struct PageBuilder<Selection: Hashable> {
  public static func buildExpression(_ page: Page<Selection, some View, some View>) -> [AnyPage<Selection>] {
    [AnyPage(id: page.id, content: AnyView(page.content), label: AnyView(page.label))]
  }

  public static func buildBlock(_ components: [AnyPage<Selection>]...) -> [AnyPage<Selection>] {
    components.flatMap(\.self)
  }

  public static func buildOptional(_ component: [AnyPage<Selection>]?) -> [AnyPage<Selection>] {
    component ?? []
  }

  public static func buildEither(first component: [AnyPage<Selection>]) -> [AnyPage<Selection>] {
    component
  }

  public static func buildEither(second component: [AnyPage<Selection>]) -> [AnyPage<Selection>] {
    component
  }
}

extension PageBuilder where Selection == Int {
  public static func buildBlock(_ components: [AnyPage<Selection>]...) -> [AnyPage<Selection>] {
    components.flatMap(\.self).enumerated().map { index, page in
      AnyPage(id: index, content: page.content, label: page.label)
    }
  }
}

// MARK: - PagerView

public struct PagerView<Selection: Hashable>: View {
  private let pages: [AnyPage<Selection>]
  @Binding private var externalSelection: Selection
  @State private var internalSelection: Selection
  private let usesExternalBinding: Bool

  public init(
    selection: Binding<Selection>,
    @PageBuilder<Selection> content: () -> [AnyPage<Selection>]
  ) {
    self.pages = content()
    self._externalSelection = selection
    self._internalSelection = State(initialValue: selection.wrappedValue)
    self.usesExternalBinding = true
  }

  private var selection: Binding<Selection> {
    if usesExternalBinding {
      return $externalSelection
    } else {
      return $internalSelection
    }
  }

  public var body: some View {
    contentView()
      .safeAreaInset(edge: .top, spacing: 0) {
        VStack(spacing: 0) {
          tabsView()
          dividerView()
        }
      }
      .animation(.easeInOut(duration: 0.2), value: selection.wrappedValue)
  }

  @ViewBuilder
  private func tabsView() -> some View {
    HStack(spacing: 4) {
      ForEach(pages) { page in
        Button {
          selection.wrappedValue = page.id
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
      if pages.isEmpty {
        Color.clear.frame(height: 4)
      } else {
        GeometryReader { proxy in
          let count = CGFloat(pages.count)
          let tabWidth = proxy.size.width / count
          let selectedIndex = pages.firstIndex { $0.id == selection.wrappedValue } ?? 0

          RoundedRectangle(cornerRadius: 2)
            .fill(Color.accentColor)
            .frame(width: tabWidth, height: 4)
            .offset(x: tabWidth * CGFloat(selectedIndex))
        }
        .frame(height: 4)
      }

      Divider()
    }
  }

  @ViewBuilder
  private func contentView() -> some View {
    TabView(selection: selection) {
      ForEach(pages) { page in
        page.content
          .tag(page.id)
      }
    }
    .frame(maxHeight: .infinity)
    .tabViewStyle(.page(indexDisplayMode: .never))
  }
}

extension PagerView where Selection == Int {
  public init(@PageBuilder<Int> content: () -> [AnyPage<Selection>]) {
    self.pages = content()
    self._externalSelection = .constant(0)
    self._internalSelection = State(initialValue: 0)
    self.usesExternalBinding = false
  }
}

#Preview("Int Selection (Backward Compatible)") {
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

#Preview("Custom Selection Type") {
  enum Tab: Hashable {
    case home, search, account
  }

  struct ContentView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
      PagerView(selection: $selectedTab) {
        Page(id: Tab.home) {
          Text("Home Content")
        } label: {
          Text("Home")
        }

        Page(id: Tab.search) {
          Text("Search Content")
        } label: {
          Text("Search")
        }

        Page(id: Tab.account) {
          Text("Account Content")
        } label: {
          Text("Account")
        }
      }
    }
  }

  return ContentView()
}
