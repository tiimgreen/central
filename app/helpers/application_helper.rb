module ApplicationHelper
  include HolidaysHelper

  def on_page(cont, act = '')
    if act.present?
      controller.controller_name == cont.downcase &&
      controller.action_name == act.downcase
    else
      controller.controller_name == cont.downcase
    end
  end

  def header_should_be_displayed
    !on_page('sessions', 'new') &&
    !on_page('registrations', 'new') &&
    !on_page('passwords', 'new') &&
    !on_page('passwords', 'create')
  end
end
