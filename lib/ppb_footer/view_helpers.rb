# -*- coding: utf-8 -*-

require 'open-uri'
require 'resolv-replace'
require 'timeout'
require 'digest/md5'
require 'fileutils'
require 'erb'
require 'csv'

module PpbFooter
  module ViewHelpers
    CACHE_LIFE = 3600
    TIMEOUT = 3

    def render_pc_footer
      content = ''
      retry_count = 1
      group_csv   = 'http://www.paperboy.co.jp/footer/paperboy_footer_group.csv'
      service_csv = 'http://www.paperboy.co.jp/footer/paperboy_footer.csv'

      begin
        groups = timeout(TIMEOUT) do
          open(group_csv, 'r:Shift_JIS') do |file|
            CSV.parse(file.read.encode('utf-8')).map { |row|
              if row.length >= 2
                {
                  :id   => row[0].to_i,
                  :text => row[1],
                }
              end
            }.compact
          end
        end

        services = timeout(TIMEOUT) do
          open(service_csv, 'r:Shift_JIS') do |file|
            CSV.parse(file.read.encode('utf-8')).map { |row|
              if row.length >= 4
                {
                  :title    => row[0],
                  :url      => row[1],
                  :text     => row[2],
                  :group_id => row[3].to_i,
                }
              end
            }.compact
          end
        end

        groups = groups.sort_by {|group| group[:id]}.map do |group|
          group[:services] = services.select do |service|
            service.has_key?(:group_id) and service[:group_id] == group[:id]
          end
          group
        end

        content = ERB.new(<<HTML).result(binding)
<% groups.each do |group| %>
  <dl>
    <dt><%= group[:text] %></dt>
    <% group[:services].each do |service| %>
    <dd><a href="<%= service[:url] %>" target="_blank" title="<%= service[:title] %>"><%= service[:text] %></a></dd>
    <% end %>
  </dl>
<% end %>
HTML
      rescue StandardError, TimeoutError => e
        here        = File.dirname(__FILE__)
        group_csv   = File.join(here, '../../data/paperboy_footer_group.csv')
        service_csv = File.join(here, '../../data/paperboy_footer.csv')
        if retry_count > 0
          retry_count -= 1
          retry
        end
      end

      content
    end
    module_function :render_pc_footer

    def open_with_cache(service, ssl = false)
      FileUtils.mkdir_p(cache_base_path)

      url = if ssl
              "https://secure.paperboy.co.jp/sp_footer/?service=#{service}&charset=UTF-8"
            else
              "http://www.paperboy.co.jp/sp_footer/?service=#{service}&charset=UTF-8"
            end

      hash     = Digest::MD5.new.update(url).to_s
      filename = cache_base_path + "paperboy_smartphone_#{service}_footer_#{hash}"

      if File.exist?(filename)
        content = open(filename, 'r:utf-8').read
        cache_elapse = Time.now - File.mtime(filename)
        File.delete(filename) if cache_elapse > CACHE_LIFE
      else
        begin
          timeout(TIMEOUT) do
            content = if defined?(Encoding)
                        open(url, "r:utf-8").read
                      else
                        open(url).read
                      end
            open(filename, 'w:utf-8') {|f| f.write(content) }
          end
        rescue StandardError, TimeoutError => e
          content = ''
        end
      end
      content
    end
    module_function :open_with_cache

    def cache_base_path
      root = if Rails.root.class == Pathname
               Rails.root.to_s
             else
               Rails.root
             end
      root + '/tmp/cache/'
    end
    module_function :cache_base_path
  end
end
