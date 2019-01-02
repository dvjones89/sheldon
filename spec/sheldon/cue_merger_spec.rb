require "spec_helper"

describe CueMerger do

  before(:each) do
    FileUtils.rm_r("spec/Users") if Dir.exist?("spec/Users")
    FileUtils.mkdir_p("spec/Users/test/sheldon")
    FileUtils.mkdir_p("spec/Users/test/dotfiles")
    FileUtils.touch(abs_learn_path)
  end

  let(:brain) { Brain.new(abs("spec/Users/test/sheldon")) }
  let(:abs_learn_path) { abs("spec/Users/test/dotfiles/.gitconfig") }
  let(:git_directory) { abs("spec/Users/test/sheldon/git-scratch") }
  let(:cue_merger) { CueMerger.new(brain) }

  describe "#merge" do

    before(:each) do
      brain.learn("my git config", abs_learn_path)
      FileUtils.touch(abs_learn_path)
    end

    it "should create a git-temp directory in Sheldon's brain" do
      expect(Dir).not_to exist(git_directory)
      cue_merger.merge!("my git config", File.new(abs_learn_path))
      expect(Dir).to exist(git_directory)
    end

  end

end
