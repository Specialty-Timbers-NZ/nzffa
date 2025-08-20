Radiant.config do |config|
  config.namespace('stnz') do |stnz|
    %w(past_members non_renewed_members resigned_members newsletter_editors secretarys
      fft_marketplace fft_newsletter st).each do |name|
      stnz.define "#{name}_group_id", :select_from => lambda {Group.all.map{|l| [l.name, l.id.to_s]}}, :allow_blank => true
    end
    
    stnz.define 'admin_levy', :value => 0
  end
end