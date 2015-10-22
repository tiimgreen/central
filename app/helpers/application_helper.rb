module ApplicationHelper

  def on_page(cont, act = '')
    if act.present?
      controller.controller_name == cont.downcase &&
      controller.action_name == act.downcase
    else
      controller.controller_name == cont.downcase
    end
  end
end
