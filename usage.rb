### Don't use as a script; copy necessary lines into irb

### Initialization
require 'mustpl'
require 'vk-ruby'
require 'rmega'

require 'pp'

def expand(path); File.expand_path(path); end


### Create a new VK session
# Read key.rb and put your key there for this to work
load 'key.rb'
$s = MuStPl::VKSession.new(
  VK::Application.new(app_id: MuStPl::VKStorage::AppID,
                      access_token: $vk_key,
                      version: '5.28'))

### Create a new collection
$c = MuStPl::SongCollection.new(
  expand("~/MEGA/music"),
  [
    MuStPl::VKStorage.new(:vk, $s),
    MuStPl::LocalStorage.new(
      :vk_local, expand("~/lab/music/vk"), :vk_local_path)
  ],
  [:vk_local, :vk]); nil
$c.save

### or
### Read an existing collection
$c = MuStPl::SongCollection.load(expand "~/MEGA/music"); nil
# Get VK session from the collection
$s = $c.storage[:vk].vk_s
# Take a list from collection
m = $c.lists["vk"]; nil

### Get VK music
a = $s.get_music; nil

# Convert received music into mustpl list
m = $c.storage[:vk].import("vk", a); nil
# Add references to locally-stored copies of VK songs
MuStPl::VKStorage.link_to_local_storage!(m, $c.storage[:vk_local]); nil

### Put a list into collection
# TODO rename add->put
$c.add_list m; nil

### Convert a list to an m3u file
# args:  collection priorities resulting-file
m.to_m3u(expand("~/test.m3u"))

m.shuffle[0..400].to_m3u(expand("~/part.m3u"))

l = $c.storage[:vk].import(
  "search: russian circles",
  $s.find_music("russian circles", count: 300)); nil
l.to_m3u(expand("~/search-test.m3u"))

### Reload URLs (and other info?) of songs-from-vk in a list
# Otherwise, if the list is created long ago, the URLs won't work
$c.storage[:vk].reload_vk_songs m; nil
# Make m3u from filtered list
m.select { |x| x.text_fields_match /russian circles/i }\
  .to_m3u(expand("~/circles.m3u"))


### Add MEGA Storage
# Not fully ready - no 'load'able representation
# so don't save the collection you add this to
load 'mega-creds.rb'
$c.add_storage(MuStPl::MEGAStorage.new(
                :vk_mega,
                email: $mega_email,
                mega_storage: Rmega.login($mega_email, $mega_password),
                root: "vk-music",
                path_option: :vk_local_path))

# Add references to downloaded VK music (mp3's) stored in MEGA
m = $c.lists["vk"]; nil
MuStPl::VKStorage.link_to_local_storage!(m, $c.storage[:vk_mega]); nil

# make m3u from random 100 songs
m.shuffle[0..100].to_m3u(expand("~/part-test.m3u"),
                         prio: [:vk_mega, :vk])
