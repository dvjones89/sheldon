class FileMerger
  require 'git'

  def initialize(brain, cue)
    @brain = brain
    @cue = cue
    # @git_directory = File.join(brain.location, "git-temp")
    @git_directory = File.join("/Users/dave/Desktop", "git-test")
    @git_scratchfile = File.join(@git_directory, "scratch.txt")
  end

  def merge!(path_to_users_file)
    setup_git_scratchpad
  end

  private

  def setup_git_scratchpad
    git = Git.init(@git_directory)
    File.open(@git_scratchfile, "w") { |f| f.write("") }
    git.add
    git.commit("initial commit")
  end
end
