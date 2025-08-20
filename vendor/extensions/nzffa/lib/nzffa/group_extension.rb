module Nzffa::GroupExtension

  def self.included(klass)
    klass.class_eval do

      %w(past_members past_casual_members newsletter_editors secretarys
      fft_marketplace fft_newsletter st).each do |gname|
        eval "def self.#{gname}_group; find(Radiant::Config['stnz.#{gname}_group_id']); end"
      end

      def self.fft_group
        find(StnzSettings.fft_marketplace_group_id)
      end
    end
  end

  def has_annual_levy?
    # is_branch_group? || is_action_group? || is_fft_group? || is_tgm_group?
    is_fft_group?
  end

  def is_fft_group?
    id == StnzSettings.fft_marketplace_group_id
  end

end
