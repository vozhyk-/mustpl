load 'key.rb'
require 'mustpl'
require 'vk-ruby'

require 'pp'

def reload(require_regex)
  $".grep(/#{require_regex}/).each {|e| $".delete(e) && require(e) }
end

$s = MuStPl::VKSession.new(
  VK::Application.new(app_id: MuStPl::VKStreamStorage::AppID,
                      access_token: $vk_key,
                      version: '5.28'))

$u = MuStPl::User.new
$u.storage["vk"] = MuStPl::VKStreamStorage.new($s)
$u.storage["vk-local"] = MuStPl::LocalStreamStorage.new(
  "/home/vozhyk/lab/music/vk", :vk_local_path)

a = $s.get_music; nil

m = a.to_mustpl("vk"); nil
MuStPl::VKStreamStorage::link_to_local_storage!(m, $u, "vk-local"); nil

m.to_m3u($u, ["vk-local", "vk"], "test.m3u")
