defmodule Hyperpaste.MixProject do
  use Mix.Project

  @app :hyperpaste
  #@source_url "https://github.com/tynanbe/#{@app}"

  def project do
    [
      app: @app,
      version: "0.1.0",
      description: "Split and paste text piece by piece",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      erlc_paths: ["src", "gen"],
      compilers: [:gleam | Mix.compilers()],
      deps: deps(),
      escript: escript(),
      preferred_cli_env: [eunit: :test],
    ]
  end

  def application do
    [
      extra_applications: [:logger],
    ]
  end

  defp deps do
    [
      {:gleam_stdlib, "~> 0.16"},
      {:mix_eunit, "~> 0.3"},
      {:mix_gleam, "~> 0.1"},
      {:shellout, "~> 0.1"},
    ]
  end

  defp escript do
    [
      main_module: @app,
      path: "_build/default/bin/#{@app}",
    ]
  end
end
