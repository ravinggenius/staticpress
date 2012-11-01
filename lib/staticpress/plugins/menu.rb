module Staticpress::Plugins
  module Menu
    def root_menu
      menu 1
    end

    def menu(max_depth, menu_items = root_menu_items, menu_options = {})
      if (menu_items.count > 0) && !max_depth.zero?
        tag :menu, { :type => :toolbar }.merge(menu_options) do
          menu_items.sort.map do |item|
            tag :li do
              a = tag :a, :href => item.url_path do
                item.text
              end
              remaining_depth = (max_depth < 0) ? max_depth : max_depth - 1
              sub = menu(remaining_depth, item.sub_items, menu_options) || ''
              a + sub
            end
          end.join("\n")
        end
      end
    end

    def sub_menu_for(page)
      convert_to_menu_item(page).sub_items
    end

    def menu_pages
      @menu_pages ||= lambda do
        Staticpress::Content::Page.published.reject do |page|
          page.meta.menu.nil?
        end
      end.call
    end

    def convert_to_menu_item(page)
      parent_position = page.meta.menu.position.to_s
      matcher = /^#{parent_position.gsub('.', '\.')}\.(?<sub_position>-?\d{1,})$/
      sub_items = menu_pages.select do |sub_page|
        matcher.match sub_page.meta.menu.position.to_s
      end.map do |sub_page|
        convert_to_menu_item sub_page
      end
      MenuItem.new parent_position.split('.').last, page.meta.menu.text || page.title, page.url_path, sub_items
    end

    def menu_depth(position)
      position.split('.').count - 1
    end

    def root_menu_items
      menu_pages.select do |page|
        menu_depth(page.meta.menu.position.to_s).zero?
      end.map do |page|
        convert_to_menu_item page
      end
    end

    class MenuItem
      attr_reader :position, :text, :url_path, :sub_items

      def initialize(position, text, url_path, sub_items = [])
        @position = position.to_i
        @text = text
        @url_path = url_path
        @sub_items = sub_items
      end

      def <=>(other)
        reply = case
          when (position < 0) && (other.position < 0) then other.position.abs <=> position.abs
          when (position < 0) || (other.position < 0) then other.position <=> position
          else                                             position <=> other.position
        end
        reply.zero? ? (text <=> other.text) : reply
      end
    end
  end
end
