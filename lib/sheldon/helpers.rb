module Helpers

  def locate_brain
    relative_path = '~/sheldon2'
    # relative_path = ENV['SHELDON_DATA_DIR'] || '~/sheldon'
    Pathname(relative_path).expand_path # Deals with the use of ~ when referencing home directories
  end

  def load_db
    YAML::Store.new(File.join(locate_brain, 'db.yaml'))
  end

  def remove_home(path)
    home_path = Pathname(File.expand_path('~'))
    Pathname(path).relative_path_from(home_path).to_s
  end

  def add_home(path)
    abs_home = File.expand_path('~')
    File.join(abs_home,path).to_s
  end

end
