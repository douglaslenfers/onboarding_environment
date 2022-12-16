defmodule ToolsChallenge.Clients.MailerClient do
  def send_report() do
    HTTPoison.post(get_url(), "")
  end

  defp get_url(), do: Application.get_env(:tools_challenge, :mailer_url)
end
