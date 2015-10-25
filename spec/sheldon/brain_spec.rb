require "spec_helper"

describe Brain do

  before(:each) do
    FileUtils.rm_r("spec/Users") if Dir.exists?("spec/Users")
    FileUtils.mkdir_p("spec/Users/test/sheldon")
    FileUtils.touch("spec/Users/test/.gitconfig")
  end

  after(:each) do
    FileUtils.rm_r("spec/Users")
  end

  let(:brain) { Brain.new(abs("spec/Users/test/sheldon")) }

  describe "#learn" do
    it "should move the target file/folder into Sheldon's brain" do
      synapse_path = "spec/Users/test/sheldon/my git config/.gitconfig"
      brain.learn("my git config", "spec/Users/test/.gitconfig")
      expect(File.exists?(synapse_path)).to be true
    end
  end

  describe "#recall" do
    it "should symlink from Sheldon's brain back to the original file-system location" do
      brain.learn("my git config", "spec/Users/test/.gitconfig")
      brain.recall("my git config", "spec/Users/test/.gitconfig")
      expect(File.symlink?("spec/Users/test/.gitconfig")).to be true
    end
  end

  describe "#memory" do
    it "should return an instance of Memory" do
      expect(brain.memory).to be_a Memory
    end
  end

end
