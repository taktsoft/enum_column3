require 'test_helper'

class ViewsTest < Test::Unit::TestCase
  attr_reader :view

  def setup
    @view = ViewEnum.new
    @view.instance_variable_set('@test', Enumeration.new({:color => :blue, :severity => :medium}))
  end

  def test_helper
    body = view.render :inline => "<%= @test.color %>"
    assert_equal 'blue', body.strip
  end

  def test_view_helper
    body = view.render :inline => ViewEnum::FORM_TAG_HELPER_VIEW
    assert !body.empty?
  end

  def test_form_helper
    body = view.render :inline => ViewEnum::FORM_HELPER_VIEW
    assert !body.empty?
  end
end