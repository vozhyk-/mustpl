load 'key.rb'
require 'mustpl'
require 'vk-ruby'

require 'pp'

$s = MuStPl::VKSession.new(
  VK::Application.new(app_id: MuStPl::VKStreamStorage::AppID,
                      access_token: $vk_key,
                      version: '5.28'))

$u = MuStPl::User.new
$u.storage["vk"] = MuStPl::VKStreamStorage.new($s)

a = $s.get_music; nil

m = a.to_mustpl("vk"); nil

m.to_m3u($u, "test.m3u")
