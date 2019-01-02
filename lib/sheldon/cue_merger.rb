class CueMerger
  require 'git'

  def initialize(brain)
    @brain = brain
    @git_directory = File.join(brain.location, "git-scratch")
  end

  def merge!(cue, file_to_merge)
    git = Git.init(@git_directory)
    FileUtils.cp(file_to_merge.path, @git_directory)
  end
end
