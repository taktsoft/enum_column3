require 'test_helper'

class ViewsTest < Test::Unit::TestCase
  attr_reader :view

  def setup
    @view = ViewEnum.new
    @view.instance_variable_set('@test', Enumeration.new({:color => :blue, :severity => :medium}))
  end

  def test_helper
    body = view.render :inline => "<%= @test.color %>"
    assert_equal 'blue', body
  end

  def test_view_helper
    body = view.render :inline => "<%= enum_select('test', 'severity') %>" 
    assert_equal '<select id="test_severity" name="test[severity]"><option value="low">low</option>
<option value="medium" selected="selected">medium</option>
<option value="high">high</option>
<option value="critical">critical</option></select>', body
  end
end