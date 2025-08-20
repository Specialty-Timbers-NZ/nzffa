class AppliesSubscriptionGroups
  def self.apply(subscription, reader)
    if subscription.active?
      #remove past members group if they exist
      reader.memberships.find_all_by_group_id([
        StnzSettings.past_members_group_id,
        StnzSettings.non_renewed_members_group_id,
        StnzSettings.non_renewed_fft_members_group_id,
        StnzSettings.resigned_members_group_id]).each(&:destroy)

      if subscription.belongs_to_fft
        # swap with fft_newsletter if it exists
        reader.memberships.find_all_by_group_id(StnzSettings.fft_newsletter_group_id).each(&:destroy)
        reader.groups << Group.fft_marketplace_group
      end
      # Although 'full membership' is no longer a thing, collect all active members in this group;
      reader.groups << Group.full_membership_group

      subscription.groups.each do |group|
        reader.groups << group
      end
    end

  end

  def self.remove(subscription, reader = nil)
    # Is only ever called from rake task, not from controller
    reader = subscription if reader.nil?
    return true if reader.is_resigned?
    # find old subscription and add to 'swap' groups
    group_ids_to_delete = []
    group_ids_to_delete << StnzSettings.fft_marketplace_group_id
    group_ids_to_delete << StnzSettings.full_membership_group_id

    group_ids_to_add = []
    if reader.subscriptions.active_anytime.any?
      subscr = reader.subscriptions.active_anytime.last
      group_ids_to_add << StnzSettings.past_members_group_id
      if reader.group_ids.include? StnzSettings.fft_marketplace_group_id
        group_ids_to_add << StnzSettings.fft_newsletter_group_id
      end
    end

    group_ids_to_delete.each do |group_id|
      reader.memberships.find_all_by_group_id(group_id).each(&:destroy)
    end
    group_ids_to_add.each do |group_id|
      reader.memberships.create(:group_id => group_id)
    end
  end
end
