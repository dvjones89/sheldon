require "spec_helper"
require "byebug"

describe Brain do

  before(:each) do
    FileUtils.rm_r("spec/Users") if Dir.exists?("spec/Users")
    FileUtils.mkdir_p("spec/Users/test/sheldon")
    FileUtils.mkdir_p("spec/Users/test/dotfiles")
    FileUtils.touch("spec/Users/test/dotfiles/.gitconfig")
  end

  let(:memory) { Memory.new(abs("spec/Users/test/sheldon")) }
  let(:brain) { Brain.new(abs("spec/Users/test/sheldon"), memory: memory) }
  let(:abs_learn_path) { abs("spec/Users/test/dotfiles/.gitconfig") }
  let(:abs_brain_path) { abs("spec/Users/test/sheldon/my git config/.gitconfig") }

  describe "#learn" do
    context "for a file /folder that does not exist on the filesystem" do
      it "should raise an error" do
        expect{brain.learn("my git config", "bad/file/path")}.to raise_error("Unable to find a file or folder at bad/file/path")
      end
    end

    context "for a file/folder that exists on the filesystem" do
      it "should move the target file/folder into Sheldon's brain" do
        brain.learn("my git config", abs_learn_path)
        expect(File).to exist(abs_brain_path)
      end

      it "should add a new entry to memory" do
        expect(brain.size).to eq 0
        brain.learn("my git config", abs_learn_path)
        expect(brain.size).to eq 1
      end
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

  describe "#forget" do
    before(:each){ brain.learn("my git config", abs_learn_path) }

    it "should delete the entry from Sheldon's memory" do
      expect(memory.has_cue?("my git config")).to be true
      brain.forget("my git config")
      expect(memory.has_cue?("my git config")).to be false
    end

    context "for a cue that's recalled on the local host" do
      before(:each) { brain.recall("my git config") }

      it "should delete the memorised file/folder from Sheldon's brain AND the local filesystem" do
        expect(File).to exist(abs_brain_path)
        expect(File).to exist(abs_learn_path)
        brain.forget("my git config")
        expect(File).not_to exist(abs_brain_path)
        expect(File).not_to exist(abs_learn_path)
      end
    end

    context "for a cue that is NOT recalled on the local host" do
      it "should delete the file/folder only from Sheldon's brain" do
        expect(File).to exist(abs_brain_path)
        brain.forget("my git config")
        expect(File).not_to exist(abs_brain_path)
      end
    end
  end


  describe "#recalled?" do
    context "for a file that has been recalled" do
      it "should return true" do
        brain.learn("my git config", abs_learn_path)
        brain.recall("my git config")
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
    it "should delegate to appropriate method on Sheldon's memory" do
      expect(memory).to receive(:has_cue?).once.with("lightbulb")
      brain.has_cue?("lightbulb")
    end
  end

  describe "#size" do
    it "should delegate to appropriate method on Sheldon's memory" do
      expect(memory).to receive(:size).once
      brain.size
    end
  end

  describe "#list_cues" do
    it "should delegate to appropriate method on Sheldon's memory" do
      expect(memory).to receive(:list_cues).once
      brain.list_cues
    end
  end
end
