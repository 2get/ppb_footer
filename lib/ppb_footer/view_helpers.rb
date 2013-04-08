# -*- coding: utf-8 -*-

require 'open-uri'
require 'resolv-replace'
require 'timeout'
require 'digest/md5'
require 'fileutils'

module PpbFooter
  module ViewHelpers
    CACHE_LIFE = 3600
    CACHE_BASE_PATH = RAILS_ROOT + '/tmp/cache/'

    FOOTER_URL = 'http://ppbapp.com/sp_footer/?service=30days&charset=UTF-8'

    TIMEOUT = 3

    def open_with_cache
      unless File.directory?(CACHE_BASE_PATH)
        FileUtils.mkdir_p(CACHE_BASE_PATH)
      end

      hash =     Digest::MD5.new.update(FOOTER_URL).to_s
      filename = CACHE_BASE_PATH + "paperboy_smartphone_common_footer_#{hash}"

      if File.exist?(filename)
        content = open(filename, 'r:UTF-8').read
        cache_elapse = Time.now - File.mtime(filename)
        File.delete(filename) if cache_elapse > CACHE_LIFE
      else
        begin
          timeout(TIMEOUT) do
            content = open(FOOTER_URL).read
            open(filename, 'w:UTF-8') {|f| f.write(content) }
          end
        rescue StandardError, TimeoutError => e
          content = ''
        end
      end
      content
    end

    module_function :open_with_cache
  end
end