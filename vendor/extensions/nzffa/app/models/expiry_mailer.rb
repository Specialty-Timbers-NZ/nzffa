class ExpiryMailer < ActionMailer::Base
  def warning_email(advert)
    #recipients advert.reader.email
    @advert = advert
    recipients advert.reader.email
    from "NZST Marketplace <admin@specialtytimbers.nz>"
    subject 'Your listing will expire in 7 days'
    content_type  "text/html"
    reply_to 'admin@specialtytimbers.nz'
    sent_on Time.now
    body
  end
end
