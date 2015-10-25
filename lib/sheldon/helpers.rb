module Helpers

  def remove_home(path)
    home_path = Pathname(File.expand_path("~"))
    Pathname(path).relative_path_from(home_path).to_s
  end

  def add_home(path)
    abs_home = File.expand_path("~")
    File.join(abs_home, path).to_s
  end

  def abs(rel_path)
    File.expand_path(rel_path).to_s
  end

end
