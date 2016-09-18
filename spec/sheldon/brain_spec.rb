require "spec_helper"
require "byebug"

describe Brain do

  before(:each) do
    FileUtils.rm_r("spec/Users") if Dir.exists?("spec/Users")
    FileUtils.mkdir_p("spec/Users/test/sheldon")
    FileUtils.mkdir_p("spec/Users/test/dotfiles")
    FileUtils.touch("spec/Users/test/dotfiles/.gitconfig")
  end

  after(:each) do
    FileUtils.rm_r("spec/Users")
  end

  let(:memory) { Memory.new(abs("spec/Users/test/sheldon")) }
  let(:brain) { Brain.new(abs("spec/Users/test/sheldon"), memory: memory) }
  let(:abs_learn_path) { abs("spec/Users/test/dotfiles/.gitconfig") }

  describe "#learn" do
    it "should move the target file/folder into Sheldon's brain" do
      cell_path = "spec/Users/test/sheldon/my git config/.gitconfig"
      brain.learn("my git config", abs_learn_path)
      expect(File).to exist(cell_path)
    end

    it "should add a new entry to memory" do
      expect(brain.size).to eq 0
      brain.learn("my git config", abs_learn_path)
      expect(brain.size).to eq 1
    end
  end

  describe "#recall" do
    context "for a destination directory that already exists" do
      it "should symlink from Sheldon's brain back to the original file-system location" do
        brain.learn("my git config", abs_learn_path)
        brain.recall("my git config")
        expect(File).to be_symlink("spec/Users/test/dotfiles/.gitconfig")
      end
    end

    context "for a destination directory that doesn't exist" do
      it "should create the destination directory and then perform the symlink" do
        brain.learn("my git config", abs_learn_path)
        FileUtils.rm_r("spec/Users/test/dotfiles")
        brain.recall("my git config")
        expect(Dir).to exist("spec/Users/test/dotfiles")
        expect(File).to be_symlink("spec/Users/test/dotfiles/.gitconfig")
      end
    end
  end

  describe "#recalled?" do
    context "for a file that has been recalled" do
      it "should return true" do
        brain.learn("my git config", abs_learn_path)
        brain.recall("my git config")
        expect(brain.recalled?("my git config")).to be true
      end
    end

    context "for a file that has not been recalled" do
      it "should return false" do
        brain.learn("my git config", abs_learn_path)
        expect(brain.recalled?("my git config")).to be false
      end
    end

    context "for a broken symlink" do
      it "should return false" do
        brain.learn("my git config", abs_learn_path)
        brain.recall("my git config")
        FileUtils.rm("spec/Users/test/sheldon/my git config/.gitconfig")
        expect(File.symlink?(abs_learn_path)).to be true
        expect(File.exists?("spec/Users/test/sheldon/my git config/.gitconfig")).to be false
        expect(brain.recalled?("my git config")).to be false
      end
    end
  end

  describe "#has_cue?" do
    it "should delegate to memory#has_cue?" do
      expect(memory).to receive(:has_cue?).once.with("lightbulb")
      brain.has_cue?("lightbulb")
    end
  end

  describe "#size" do
    it "should delegate to memory#size" do
      expect(memory).to receive(:size).once
      brain.size
    end
  end

  describe "#list_cues" do
    it "should delegate to memory#list_cues" do
      expect(memory).to receive(:list_cues).once
      brain.list_cues
    end
  end

end
