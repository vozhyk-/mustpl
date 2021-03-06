Gem::Specification.new do |s|
  s.name        = 'mustpl'
  s.version     = '0.1.0'
  s.date        = '2015-02-03'
  s.summary     = "Playlists with multiple storage"
  s.description = "Playlists with multiple storage (local, MEGA, vk)"
  s.authors     = ["Vitaut Bajaryn"]
  s.email       = 'vitaut.bayaryn@gmail.com'
  s.files       = ["lib/mustpl.rb",
                   "lib/mustpl/save-load.rb",
                   "lib/mustpl/main.rb",
                   "lib/mustpl/song.rb",
                   "lib/mustpl/songlist.rb",
                   "lib/mustpl/vk.rb",
                   "lib/mustpl/collection.rb",
                   "lib/mustpl/storage-local.rb",
                   "lib/mustpl/storage-mega.rb",
                   "lib/mustpl/storage-vk.rb",
                   "lib/mustpl/storage-with-root.rb",
                  ]
  s.homepage    =
    'https://github.com/vozhyk-/mustpl'
  s.license     = 'BSD-2'
end
