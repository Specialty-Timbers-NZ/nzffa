module UpdateReaderNewsletterPreferences
  protected
  def update_newsletter_preference
    group = Group.find(NzffaSettings.fft_newsletter_group_id)

    if params["receive_fft_newsletter"]
      unless @reader.groups.include? group
        @reader.groups << group
        @newsletter_alert = "Subscribed to newsletter."
      end
    else
      if @reader.groups.include? group
        @reader.groups.delete(group)
        @newsletter_alert = "Unsubscribed from newsletter."
      end
    end
  
  end
end
