# -*- coding: utf-8 -*-

require 'open-uri'
require 'resolv-replace'
require 'timeout'
require 'digest/md5'
require 'fileutils'

module PpbFooter
  module ViewHelpers
    CACHE_LIFE = 3600
    TIMEOUT = 3

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

    private

    def cache_base_path
      root = if Rails.root.class == Pathname
               Rails.root.to_s
             else
               Rails.root
             end
      root + '/tmp/cache/'
    end
  end
end
