defmodule MixAddDep do
  @without_parens_pattern ~r/(defmodule|use|require|import|def|defp)\((.*)\)/

  def main(deps) do
    fetch_mix_file!()
    |> parse!()
    |> add_deps!(deps)
    |> encode!()
    |> write!()
  end

  defp fetch_mix_file! do
    File.read("mix.exs")
    |> unwrap_or_raise("""
    I Couldn't read a mix.exs file in the current directory. Are you sure this is an Elixir project?
    """)
  end

  defp parse!(file) do
    Code.string_to_quoted(file)
    |> unwrap_or_raise("""
    I Failed to parse the mix.exs file. Are you sure it's valid and compilable?
    """)
  end

  defp add_deps!(quoted, deps) do
    quoted_deps =
      Enum.map(deps, fn string_dep ->
        Code.string_to_quoted(string_dep)
        |> unwrap_or_raise("""
        The following dep doesn't seem to be valid, or at least I don't know how to
        create an AST for it: #{string_dep}
        """)
      end)

    Macro.prewalk(quoted, :not_found, fn
      {:defp, a, [{:deps, b, c}, [do: current_deps]]}, :not_found ->
        {{:defp, a, [{:deps, b, c}, [do: current_deps ++ quoted_deps]]}, :found}

      node, state ->
        {node, state}
    end)
    |> case do
      {ast, :found} ->
        ast

      {_, :not_found} ->
        raise """
        I wasn't able to find the `defp deps` definition in the mix.exs file.
        Are you sure it exists?
        """
    end
  end

  defp encode!(quoted) do
    file = Macro.to_string(quoted)

    Regex.scan(@without_parens_pattern, file)
    |> Enum.reduce(file, fn [match, type, args], file ->
      String.replace(file, match, Enum.join([type, args], " "))
    end)
    |> Code.format_string!()
  end

  defp write!(file) do
    File.write!("mix.exs", file)
  end

  defp unwrap_or_raise({:ok, value}, _), do: value

  defp unwrap_or_raise(_, error_message), do: raise(error_message)
end
