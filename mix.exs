defmodule SetPartitions.MixProject do
  use Mix.Project

  def version, do: "0.1.0"

  def app, do: :set_partitions

  def project do
    [
      app: app(),
      version: version(),
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: git_repository(),
      docs: docs(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.28", only: :dev, runtime: false},
    ]
  end

  defp description do
    """
    Set partitioning à la carte

    Inspired by M. Orlov, 2002, 'Efficient Generation of Set Partitions'
    """
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => git_repository(),
        "Paper" => "http://www.informatik.uni-ulm.de/ni/Lehre/WS03/DMM/Software/partitions.pdf",
        "Changelog" => "https://hexdocs.pm/#{app()}/changelog.html",
      },
    ]
  end

  def docs do
    [
      extras: [
        "CHANGELOG.md": [title: "Changelog"],
        "README.md": [title: "Overview"],
      ],
      api_reference: false,
      main: "readme",
      source_url: git_repository(),
      source_ref: "v#{version()}",
    ]
  end

  defp git_repository do
    "https://github.com/Shakadak/#{app()}.ex"
  end
end
