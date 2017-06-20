require "spec_helper"

describe Brain do

  before(:each) do
    FileUtils.rm_r("spec/Users") if Dir.exists?("spec/Users")
    FileUtils.mkdir_p("spec/Users/test/sheldon")
    FileUtils.mkdir_p("spec/Users/test/dotfiles")
    FileUtils.touch("spec/Users/test/dotfiles/.gitconfig")
  end

  let(:brain) { Brain.new(abs("spec/Users/test/sheldon")) }
  let(:abs_learn_path) { abs("spec/Users/test/dotfiles/.gitconfig") }
  let(:abs_brain_path) { abs("spec/Users/test/sheldon/my git config/.gitconfig") }

  describe "#learn" do
    context "for a file /folder that does not exist on the filesystem" do
      it "should raise an error" do
        expect{brain.learn("my git config", "bad/file/path")}.to raise_error("Unable to find a file or folder at bad/file/path")
      end
    end

    context "for an empty cue" do
      it "should raise an error" do
        expect{ brain.learn(" ", abs_learn_path) }. to raise_error("recall cue cannot be empty.")
      end
    end

    context "for a cue that already exists in Sheldon's memory" do
      it "should raise an error" do
        brain.learn("my git config", abs_learn_path)
        expect{ brain.learn("my git config", abs_learn_path) }.to raise_error("This cue has already been used.")
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
      expect(brain.has_cue?("my git config")).to be true
      brain.forget("my git config")
      expect(brain.has_cue?("my git config")).to be false
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

    context "for a cue that does not exist in Sheldon's memory" do
      it "should raise an error" do
        expect{ brain.recalled?("lightbulb") }.to raise_error("no entry for cue 'lightbulb'")
      end
    end
  end

  # Smoke-test
  describe "#has_cue?" do
    context "for a cue that has previously been learnt" do
      it "should return true" do
        brain.learn("my git config", abs_learn_path)
        expect(brain.has_cue?("my git config")).to be true
      end
    end
  end

# Smoke-test
  describe "#size" do
    context "for a brain that has learnt a single cue" do
      it "should return 1" do
        brain.learn("my git config", abs_learn_path)
        expect(brain.size).to eq 1
      end
    end
  end

# Smoke-test
  describe "#list_cues" do
    context "for a brain that has learnt a single cue" do
      it "should return the single cue" do
        brain.learn("my git config", abs_learn_path)
        expect(brain.list_cues).to eq ["my git config"]
      end
    end
  end
end
