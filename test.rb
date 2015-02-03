load '~/dev/ruby/lastfm-vk/vk-music/vk-music-search.rb'
require 'mustpl'
require 'pp'

$u = MuStPl::User.new
$u.storage["vk"] = MuStPl::VKStreamStorage.new($s)

a = get_audio; nil

m = a.to_mustpl("vk"); nil

m.to_m3u($u, "test.m3u")
