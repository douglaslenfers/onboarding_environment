defmodule MailerWeb.MailerService do
  import Bamboo.Email

  alias Mailer.Mailer

  def send_email(%Bamboo.Email{} = email), do: Mailer.deliver_later(email)

  def send_email(:file_not_found), do: {:error, "File product_report.csv not found"}

  def create_email() do
    if File.exists?(get_path()) do
      new_email()
      |> to("email_to@email.com")
      |> from("email_from@email.com")
      |> subject("Products report updated")
      |> put_attachment(get_path())
    else
      :file_not_found
    end
  end

  defp get_path(), do: Application.get_env(:mailer, :report)[:path]
end
