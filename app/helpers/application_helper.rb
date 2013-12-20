module ApplicationHelper

  ##
  # Show flash messages
  def flash_message(flash)
    out = ""
    flash.each do |name, msg|
      if msg.is_a?(String) && !msg.blank? && !name.blank?
        out << %Q{
          <div class="alert alert-#{name == :notice ? "success" : "danger"}">
            <a class="close" data-dismiss="alert">&#215;</a>
            #{content_tag(:div, msg, :id => "flash_#{name}")}
          </div>
        }
      end
    end
    out.html_safe
  end

end
