class StnzSettings
  NAMES = %w[ fft_marketplace_levy
              fft_marketplace_group_id

              st_group_id

              secretarys_group_id

              past_members_group_id
              non_renewed_members_group_id
              non_renewed_fft_members_group_id
              resigned_members_group_id

              fft_newsletter_group_id ]

  class << self
    NAMES.each do |name|
      attr_accessor name
    end
  end

  def self.remove_defaults
    NAMES.each do |name|
      self.send("#{name}=", nil)
    end
  end

  @fft_marketplace_levy = Radiant::Config["stnz.full_member_marketplace_levy"].to_i

  roles = %w(secretary past_member non_renewed_member resigned_member)
  roles.each do |key|
    eval "@#{key}s_group_id = #{Radiant::Config["stnz.#{key}s_group_id"].to_i}"
  end
  @non_renewed_fft_members_group_id = Radiant::Config['stnz.non_renewed_fft_members_group_id'].to_i

  @fft_marketplace_group_id = Radiant::Config["stnz.fft_marketplace_group_id"].to_i
  @fft_newsletter_group_id = Radiant::Config["stnz.fft_newsletter_group_id"].to_i
  @st_group_id = Radiant::Config["stnz.st_group_id"].to_i
end
