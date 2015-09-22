module ApplicationHelper
  def full_title(page_title='')
    base_title ="三晋E贷"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
  
  def get_badge_style
    num = rand(100)
    if num % 5 == 0
      'am-badge-primary'
    elsif num % 5 == 2
      'am-badge-secondary'
    elsif num % 5 == 3
      'am-badge-success'
    elsif num % 5 == 4
      'am-badge-warning'
    else num % 5 == 1
      'am-badge-danger'
    end
  end
  
end
