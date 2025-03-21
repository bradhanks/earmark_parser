defmodule Support.AstHelpers do
  def assert_asts_are_equal(result, expected) do
    quote do
      assert _delta_between(unquote(Macro.escape(result)), unquote(Macro.escape(expected))) == []
    end
  end

  def ast_from_md(md, opts \\ []) do
    with {:ok, ast, []} <- EarmarkParser.as_ast(md, opts) do
      ast
    end
  end

  def ast_with_errors(md) do
    with {:error, ast, messages} <- EarmarkParser.as_ast(md) do
      {ast, messages}
    end
  end

  def p(content, atts \\ [])

  def p(content, atts) when is_binary(content) or is_tuple(content) do
    {"p", atts, [content]}
  end

  def p(content, atts) do
    {"p", atts, content}
  end

  def tag(name, content \\ nil, atts \\ []) do
    {to_string(name), _atts(atts), _content(content)}
  end

  def void_tag(tag, atts \\ []) do
    {to_string(tag), atts, []}
  end

  defp _atts(atts) do
    atts |> Enum.into(Keyword.new()) |> Enum.map(fn {x, y} -> {to_string(x), to_string(y)} end)
  end

  defp _content(c)

  defp _content(nil) do
    []
  end

  defp _content(s) when is_binary(s) do
    [s]
  end

  defp _content(c) do
    c
  end
end

# SPDX-License-Identifier: Apache-2.0
