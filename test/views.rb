class ViewEnum < ActionView::Base
  FORM_TAG_HELPER_VIEW = <<-EOS
    <%= enum_select('test', 'severity') %>
EOS
  FORM_HELPER_VIEW = <<-EOS
  <%= form_for(@test, {:url => '/test', :html => {}}) do |f| %>
    <%= f.enum_select :color %>
    <%= f.enum_select :severity %>
  <% end %>
EOS

  def protect_against_forgery?
    false
  end
end