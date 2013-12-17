module MessageHelper
  def active_message_class(class_name="home")
    classes = {
      "messages.index"=>"home",
      "messages.new"=>"compose",
      "messages.sent"=>"sent",
      "messages.trash"=>"trash"
    }

    "active" if class_name == (classes[controller.controller_name + '.' + controller.action_name] || classes[controller.controller_name] || '')
  end
end
