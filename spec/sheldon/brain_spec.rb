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
      cell_path = "spec/Users/test/sheldon/my git config/.gitconfig"
      brain.learn("my git config", "spec/Users/test/.gitconfig")
      expect(File.exists?(cell_path)).to be true
    end

    it "should add a new entry to memory" do
      cell_path = "spec/Users/test/sheldon/my git config/.gitconfig"
      expect(brain.size).to eq 0
      brain.learn("my git config", "spec/Users/test/.gitconfig")
      expect(brain.size).to eq 1
    end
  end

  describe "#recall" do
    it "should symlink from Sheldon's brain back to the original file-system location" do
      brain.learn("my git config", "spec/Users/test/.gitconfig")
      brain.recall("my git config", "spec/Users/test/.gitconfig")
      expect(File.symlink?("spec/Users/test/.gitconfig")).to be true
    end
  end

  describe "#has_cue?" do
    it "should delegate to memory#has_cue?" do
      expect(brain.send(:memory)).to receive(:has_cue?).once.with("lightbulb")
      brain.has_cue?("lightbulb")
    end
  end

  describe "#size" do
    it "should delegate to memory#size" do
      expect(brain.send(:memory)).to receive(:size).once
      brain.size
    end
  end

end
