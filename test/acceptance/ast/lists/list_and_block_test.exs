defmodule Acceptance.Ast.Lists.ListAndBlockTest do
  use Support.AcceptanceTestCase

  describe "Block Quotes in Lists" do
    # Incorrect behavior needs to be fixed with #249 or #304
    test "two spaces" do
      markdown = "- a\n  > b"
      html = "<ul>\n<li>a<blockquote><p>b</p>\n</blockquote></li>\n</ul>\n"
      # |> IO.inspect(label: :ast)
      ast = parse_html(html)
      messages = []

      assert as_ast(markdown) == {:ok, ast, messages}
    end

    test "four spaces" do
      markdown = "- c\n    > d"
      html = "<ul>\n<li>c<blockquote><p>d</p>\n</blockquote>\n</li>\n</ul>\n"
      ast = parse_html(html)
      messages = []

      assert as_ast(markdown) == {:ok, ast, messages}
    end
  end

  # #349
  describe "Code Blocks in Lists" do
    @tag :wip
    test "Regression #349" do
      markdown = """
      * List item1

        Text1

          * List item2

        Text2

            https://mydomain.org/user_or_team/repo_name/blob/master/path

      """

      ast =
        tag(
          "ul",
          tag("li", [
            p("List item1"),
            p("Text1"),
            tag("pre", tag("code", ["* List item2"])),
            p("Text2"),
            tag("pre", tag("code", " https://mydomain.org/user_or_team/repo_name/blob/master/path"))
          ])
        )

      messages = []

      assert as_ast(markdown) == {:ok, ast, messages}
    end

    test "Regression #349/counter example" do
      markdown = """
      * List item1

        Text1

          * List item2

        Text

            https://mydomain.org/user_or_team/repo_name/blob/master/path

      """

      ast = [
        ul(
          li([
            p("List item1"),
            p("Text1"),
            ul(li("List item2")),
            p("Text"),
            pre_code("https://mydomain.org/user_or_team/repo_name/blob/master/path")
          ])
        )
      ]

      assert ast_from_md(markdown) == ast
    end
  end
end

# SPDX-License-Identifier: Apache-2.0
