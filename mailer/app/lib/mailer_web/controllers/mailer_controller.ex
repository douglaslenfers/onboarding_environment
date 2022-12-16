defmodule MailerWeb.MailerController do
  use MailerWeb, :controller

  alias Mailer.Mailer
  alias MailerWeb.MailerService

  def send(conn, _) do
    case MailerService.send_email(MailerService.create_email()) do
      {:ok, %Bamboo.Email{}} -> send_resp(conn, 202, "")
      {:error, "File product_report.csv not found" = reason} -> send_resp(conn, 500, reason)
      {:error, _} -> send_resp(conn, 500, "")
    end
  end
end
