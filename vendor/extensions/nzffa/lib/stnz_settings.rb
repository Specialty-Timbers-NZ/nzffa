class StnzSettings
  NAMES = %w[ admin_levy
              forest_size_levys
              fft_marketplace_levy
              fft_marketplace_group_id

              st_group_id

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

  @admin_levy = Radiant::Config["stnz.admin_levy"].to_i
  @forest_size_levys = {}
  ['0 - 10', '11 - 40', '41+'].each do |key|
    @forest_size_levys[key] = Radiant::Config["stnz.forest_size_#{key.gsub(' ','')}_levy"].to_i
  end
  @fft_marketplace_levy = Radiant::Config["stnz.full_member_marketplace_levy"].to_i

  roles = %w(councillor president secretary treasurer newsletter_editor past_member non_renewed_member resigned_member)
  roles.each do |key|
    eval "@#{key}s_group_id = #{Radiant::Config["stnz.#{key}s_group_id"].to_i}"
  end
  @non_renewed_fft_members_group_id = Radiant::Config['stnz.non_renewed_fft_members_group_id'].to_i

  @fft_marketplace_group_id = Radiant::Config["stnz.fft_marketplace_group_id"].to_i
  @fft_newsletter_group_id = Radiant::Config["stnz.fft_newsletter_group_id"].to_i
  @st_group_id = Radiant::Config["stnz.st_group_id"].to_i
end
