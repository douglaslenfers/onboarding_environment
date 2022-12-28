defmodule MailerWeb.ErrorHelpers do
  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(MailerWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(MailerWeb.Gettext, "errors", msg, opts)
    end
  end
end
