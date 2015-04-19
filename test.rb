### Initialization
require 'mustpl'
require 'vk-ruby'
require 'rmega'

require 'pp'

# acts like require, but reloads the files
def reload(require_regex)
  $".grep(/#{require_regex}/).each {|e| $".delete(e) && require(e) }
end

### Create a new VK session
load 'key.rb'
$s = MuStPl::VKSession.new(
  VK::Application.new(app_id: MuStPl::VKStorage::AppID,
                      access_token: $vk_key,
                      version: '5.28'))

### Create a new collection
$c = MuStPl::SongCollection.new(
  File.expand_path("~/MEGA/music"),
  [MuStPl::VKStorage.new(:vk, $s),
   MuStPl::LocalStorage.new(
     :vk_local, File.expand_path("~/lab/music/vk"), :vk_local_path)
  ]); nil

### Read an existing collection
$c = MuStPl::SongCollection.load(File.expand_path "~/MEGA/music"); nil
# Get VK session from the collection
$s = $c.storage[:vk].vk_s
m = $c.lists["vk"]; nil

### Get VK music
a = $s.get_music; nil

m = $c.storage[:vk].import("vk", a); nil
MuStPl::VKStorage.link_to_local_storage!(m, $c.storage[:vk_local]); nil

### Put the list into collection
# TODO rename add->put
$c.add_list m; nil

### Convert list to m3u file
m.to_m3u($c, [:vk_local, :vk], File.expand_path("~/test.m3u"))

m.shuffle[0..400].to_m3u($c, [:vk_local, :vk], File.expand_path("~/part.m3u"))

l = $c.storage[:vk].import(
  "search: russian circles",
  $s.find_music("russian circles", count: 300)); nil
l.to_m3u($c, [:vk_local, :vk], File.expand_path("~/search-test.m3u"))

$c.storage[:vk].reload_vk_songs m; nil
m.select { |x| x.text_fields_match /russian/i }.to_m3u($c, [:vk_local, :vk], File.expand_path("~/circles.m3u"))


### Add MEGA Storage
load 'mega-creds.rb'
$c.add_storage(MuStPl::MEGAStorage.new(
                :vk_mega,
                email: $mega_email,
                mega_storage: Rmega.login($mega_email, $mega_password),
                root: "vk-music",
                path_option: :vk_local_path))

m = $c.lists["vk"]; nil
MuStPl::VKStorage.link_to_local_storage!(m, $c.storage[:vk_mega]); nil
m.shuffle[0..100].to_m3u($c, [:vk_mega, :vk],
                         File.expand_path("~/part.m3u"))
