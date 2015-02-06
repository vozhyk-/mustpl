load 'key.rb'
require 'mustpl'
require 'vk-ruby'

require 'pp'

# acts like require, but reloads the files
def reload(require_regex)
  $".grep(/#{require_regex}/).each {|e| $".delete(e) && require(e) }
end

$s = MuStPl::VKSession.new(
  VK::Application.new(app_id: MuStPl::VKStorage::AppID,
                      access_token: $vk_key,
                      version: '5.28'))

$u = MuStPl::User.new
$u.add_storage MuStPl::VKStorage.new("vk", $s)
$u.add_storage MuStPl::LocalStorage.new(
  "vk-local", "/home/vozhyk/lab/music/vk", :vk_local_path)

a = $s.get_music; nil

m = $u.storage["vk"].import_vk_songs(a); nil
MuStPl::VKStorage::link_to_local_storage!(m, $u, "vk-local"); nil

m.to_m3u($u, ["vk-local", "vk"], "test.m3u")
