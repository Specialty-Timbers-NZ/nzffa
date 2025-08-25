module Nzffa::GroupRoleTags
  include Radiant::Taggable

  class TagError < StandardError; end

  %w(secretary president treasurer councillor newsletter_editor).each do |role|
    desc %{
      Sets the reader scope to the current group's #{role}.
      The reader id of the #{role} is to be set in a page field '#{role}_reader_id' on the homepage of this branch
      <pre><code><r:#{role}:reader>...</r:#{role}:reader></code></pre>
    }
    tag role do |tag|
      id = tag.locals.group.homepage.try(:field, role + '_reader_id').try(:content)
      tag.expand if id && tag.locals.send("#{role}=", Reader.find(id))
    end
    tag "#{role}:reader" do |tag|
      tag.locals.reader = tag.locals.send(role)
      tag.expand
    end

  end

  # desc %{
  #   Renders a link to the branch_admin page of the current group if it is a branch.
  #   You can set your own link text by using this as a double tag

  #   <pre><code><r:group:admin_link>link text</r:group:admin_link></code></pre>
  #   }
  # tag "group:admin_link" do |tag|
  #   return unless [Group.branches_holder, Group.action_groups_holder].include?(tag.locals.group.parent)
  #   url = "/branch_admin/#{tag.locals.group.id}"
  #   options = tag.attr.dup
  #   attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
  #   attributes = " #{attributes}" unless attributes.empty?
  #   text = tag.double? ? tag.expand : url
  #   %{<a href="#{url}"#{attributes}>#{text}</a>}
  # end

  def group_find_options tag
    attr = tag.attr.symbolize_keys
    options = {}

    by = (attr[:by] || 'name').strip
    order = (attr[:order] || 'asc').strip
    order_string = ''
    if Group.columns.map(&:name).include?(by)
      order_string << by
    else
      raise TagError.new("`by' attribute of `each' tag must be set to a valid field name")
    end
    if order =~ /^(asc|desc)$/i
      order_string << " #{$1.upcase}"
    else
      raise TagError.new(%{`order' attribute of `each' tag must be set to either "asc" or "desc"})
    end
    options[:order] = order_string
    options
  end
end
