module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def markdown(text)
    options = {
      hard_wrap:       false,
      link_attributes: { target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      highlight:          true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end

  def custom_time_distance(time)

    date = Date.today.beginning_of_week
    return "Today" if time.today?
    return "Tomorrow" if time == Date.tomorrow
    return "This week" if (date..date + 6.days).include?(time)
    return "Next week" if (date..date + 13.days).include?(time)
    return "Info" if  !(date..date + 13.days).include?(time)
    distance_of_time_in_words_to_now(time)
  end

end
