defmodule ToolsChallenge.Services.CsvExport do
  alias ToolsChallenge.Products

  def generate_csv() do
    products = Products.list_products("")
    |> CSV.Encoding.Encoder.encode(headers: true)
    |> Enum.to_list()
  end

  def get_path() do
    Application.get_env(:tools_challenge, :report_csv)[:path]
  end

  def write_csv() do
    File.write(get_path(), generate_csv())
  end
end
