defmodule MailerWeb.MailerControllerTest do
  use MailerWeb.ConnCase
  use Bamboo.Test

  import Mock

  alias MailerWeb.Router.Helpers, as: Routes
  alias MailerWeb.MailerService

  describe "send/2" do
    test "with the email sent", %{conn: conn} do
      conn = post(build_conn(), Routes.mailer_path(conn, :send))

      assert_email_delivered_with(subject: "Products report updated")
    end

    test "with file not found", %{conn: conn} do
      with_mock(MailerService, [:passthrough], create_email: fn -> :file_not_found end) do
        conn = post(build_conn(), Routes.mailer_path(conn, :send))

        assert_no_emails_delivered()
        assert conn.resp_body == "File product_report.csv not found"
      end
    end
  end
end
