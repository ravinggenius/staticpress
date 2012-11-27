# https://github.com/amatsuda/kaminari

module Staticpress::Plugins
  module Pagination
    def pagination_menu(current_number, menu_options = {})
      tag :menu, { :type => :toolbar }.merge(menu_options) do
        numbered_pages = Staticpress::Content::Index.published.map do |page|
          number = page.params[:number]
          pagination_item number, number, number == current_number
        end.join

        first_page = 1
        last_page = Staticpress::Content::Index.published.count

        oldest_page = pagination_item 'Oldest', first_page, current_number == first_page
        older_page = pagination_item 'Older', current_number - 1, current_number <= first_page
        newer_page = pagination_item 'Newer', current_number + 1, current_number >= last_page
        newest_page = pagination_item 'Newest', last_page, current_number == last_page

        oldest_page + older_page + numbered_pages + newer_page + newest_page
      end
    end

    def pagination_item(text, number, is_current)
      tag :li do
        if is_current
          tag :span, :class => 'current-page' do
            text
          end
        else
          tag :a, :href => "/page/#{number}" do
            text
          end
        end
      end
    end
  end
end
