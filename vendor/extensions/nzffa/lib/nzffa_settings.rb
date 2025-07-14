class NzffaSettings
  NAMES = %w[ admin_levy
              forest_size_levys
              fft_marketplace_levy

              fft_marketplace_group_id
              full_membership_group_id

              newsletter_editors_group_id
              councillors_group_id
              presidents_group_id
              secretarys_group_id
              treasurers_group_id

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

  @admin_levy = Radiant::Config["nzffa.admin_levy"].to_i

  @fft_marketplace_levy = Radiant::Config["nzffa.full_member_marketplace_levy"].to_i

  roles = %w(councillor president secretary treasurer newsletter_editor past_member non_renewed_member past_casual_member resigned_member)
  roles.each do |key|
    eval "@#{key}s_group_id = #{Radiant::Config["nzffa.#{key}s_group_id"].to_i}"
  end
  @non_renewed_fft_members_group_id = Radiant::Config['nzffa.non_renewed_fft_members_group_id'].to_i

  @fft_marketplace_group_id = Radiant::Config["nzffa.fft_marketplace_group_id"].to_i
  @fft_newsletter_group_id = Radiant::Config["nzffa.fft_newsletter_group_id"].to_i
end
