# frozen_string_literal: true

class TestMailer < ActionMailer::Base
  def test_email
    mail(
      subject: "Hello from Postmark",
      to: "jason@codebarn.com",
      from: "jason@codebarn.com",
      # html_body: "<strong>Hello</strong> dear Postmark user.",
      track_opens: "true"
    )
  end
end
