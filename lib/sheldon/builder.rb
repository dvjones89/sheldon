class Builder
  require "fileutils"

  def build(abs_build_path)
    entries = Dir.glob(abs_build_path + "/*").sort
    master_content = entries.inject("") do |buffer, entry|
      is_config?(entry) ? add_entry_to_buffer(entry, buffer) : buffer
    end

    if master_content.empty?
      return false
    else
      master_path = File.join(abs_build_path, "config")
      File.open(master_path, "w") { |f| f.write(master_content) }
      return true
    end
  end

  private

  def add_entry_to_buffer(abs_path, buffer)
    content = File.read(abs_path)
    buffer + content + "\n"
  end

  def is_config?(abs_path)
    basename = File.basename(abs_path)
    File.file?(abs_path) && basename.include?("config_") ? true : false
  end

end
