module Helpers
  require "pathname"

  def abs(rel_path)
    File.expand_path(rel_path).to_s
  end

  def announce(message)
    logo = "💥".encode("utf-8")
    puts logo + " Sheldon" + logo + "  #{message}"
  end

  def add_home(path)
    abs_home = File.expand_path("~")
    File.join(abs_home, path).to_s
  end

  def green(message)
    puts "\e[32m#{message}\e[0m"
  end

  def prompt_user(prompt)
    print(prompt + ": ")
    input = STDIN.gets.chomp.strip
    input.empty? ? nil : input
  end

  def read_from_dotfile(key)
    dotfile = YAML::Store.new(add_home(".sheldon"))
    dotfile.transaction { dotfile[key] }
  end

  def red(message)
    puts "\e[31m#{message}\e[0m"
  end

  def remove_home(path)
    home_path = Pathname(File.expand_path("~"))
    Pathname(path).relative_path_from(home_path).to_s
  end

  def with_exception_handling(&block)
    yield
  rescue Exception => e
    red(e.message)

    if debug_file_path = read_from_dotfile("debug_file_path")
      log_msg = ([Time.now.to_s] + [e.message] + e.backtrace).join("\n")
      File.open(debug_file_path, 'a') { |f| f.write(log_msg + "\n\n") }
      red("Stack trace written to #{debug_file_path}")
    else
      red("To capture a stack trace, please set debug_file_path in ~/.sheldon")
    end

    exit(1)
  end

  def write_to_dotfile(key, value)
    dotfile = YAML::Store.new(add_home(".sheldon"))
    dotfile.transaction { dotfile[key] = value }
  end

end
