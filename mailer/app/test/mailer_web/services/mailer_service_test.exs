defmodule MailerWeb.MailerServiceTest do
  use MailerWeb.ConnCase

  alias MailerWeb.MailerService

  setup_all do
    subject = "Products report updated"
    from = "email_from@email.com"
    to = "email_to@email.com"

    {:ok, data} = File.read(Application.get_env(:mailer, :report)[:path])

    [subject: subject, from: from, to: to, data: data]
  end

  describe "create_email/0" do
    test "with correct information", %{subject: subject, from: from, to: to, data: data} do
      email_info = MailerService.create_email()
      [attachment_info] = email_info.attachments

      assert email_info.subject == subject
      assert email_info.from == from
      assert email_info.to == to

      assert attachment_info.data == data
    end
  end
end
