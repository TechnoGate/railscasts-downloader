#!/usr/bin/ruby
# -*- ruby -*-
#--
#  vim:ft=ruby:fenc=UTF-8:ts=2:sts=2:sw=2:expandtab
#
#  Copyright 2010 Wael Nasreddine (TechnoGate) <wael.nasreddine@technogate.fr>
#  Copyright 2009 Maximiliano Guzman (https://github.com/maximilianoguzman)
#
#  This file is part of Cardslib
#
#  Cardslib is free software: you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation, either version 3 of the License, or (at your option) any later
#  version.
#
#  Cardslib is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
#  PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License along with
#  Cardslib. If not, see http://www.gnu.org/licenses/
#++
####

require 'rss'

p 'Downloading rss index'

rss_string = open('http://feeds.feedburner.com/railscasts').read
rss = RSS::Parser.parse(rss_string, false)
videos_urls = rss.items.map { |it| it.enclosure.url }.reverse

videos_filenames = videos_urls.map {|url| url.split('/').last }
existing_filenames = Dir.glob('*.mov')
missing_filenames = videos_filenames - existing_filenames
p "Downloading #{missing_filenames.size} missing videos"

missing_videos_urls = videos_urls.select { |video_url| missing_filenames.any? { |filename| video_url.match filename } }

missing_videos_urls.each do |video_url|
  filename = video_url.split('/').last
  p filename
  p %x(wget -c #{video_url} -O #{filename}.tmp )
  p %x(mv #{filename}.tmp #{filename} )
end
p 'Finished synchronization'