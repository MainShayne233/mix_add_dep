defmodule MixAddDep.MixProject do
  use Mix.Project

  def project do
    [
      app: :mix_add_dep,
      version: "0.1.0",
      elixir: ">= 1.9.0",
      escript: escript()
    ]
  end

  defp escript do
    [main_module: MixAddDep]
  end
end
