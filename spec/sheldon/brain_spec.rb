require "spec_helper"

describe Brain do

  before(:each) do
    FileUtils.rm_r("spec/Users") if Dir.exist?("spec/Users")
    FileUtils.mkdir_p("spec/Users/test/sheldon")
    FileUtils.mkdir_p("spec/Users/test/dotfiles")
    FileUtils.touch("spec/Users/test/dotfiles/.gitconfig")
  end

  let(:brain) { Brain.new(abs("spec/Users/test/sheldon")) }
  let(:abs_learn_path) { abs("spec/Users/test/dotfiles/.gitconfig") }
  let(:abs_brain_path) { abs("spec/Users/test/sheldon/my git config/.gitconfig") }
  let(:dotfiles_directory) { abs("spec/Users/test/dotfiles") }

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
    context "when recalling a file that already exists on the host" do
      context "when the overwrite argument hasn't been set" do
        it "should raise a runtime exception" do
          brain.learn("my git config", abs_learn_path)
          FileUtils.touch(abs_learn_path)
          expect { brain.recall("my git config") }.to raise_error(DestinationNotEmptyException)
        end
      end

      context "when the overwrite argument has been set" do
        it "should successfully symlink the file to the destination directory" do
          brain.learn("my git config", abs_learn_path)
          FileUtils.touch(abs_learn_path)
          expect(brain.recall("my git config", overwrite: true)).to be true
        end
      end
    end

    context "when recalling a folder that already exists on the host" do
      it "should raise a runtime exception" do
        brain.learn("dotfiles", dotfiles_directory)
        FileUtils.mkdir_p(dotfiles_directory)
        expect { brain.recall("dotfiles") }.to raise_error(DestinationNotEmptyException)
      end
    end

    context "when recalling a file into an existing directory" do
      it "should successully symlink the file into the directory" do
        expect(Dir).to exist(dotfiles_directory)
        brain.learn("my git config", abs_learn_path)
        brain.recall("my git config")
        expect(File).to be_symlink(abs_learn_path)
      end
    end

    context "when recalling a file to a destination that doesn't exist on the host" do
      it "should create the destination directory and then symlink the file into it" do
        brain.learn("my git config", abs_learn_path)
        FileUtils.rm_r(dotfiles_directory)
        expect(Dir).not_to exist(dotfiles_directory)
        brain.recall("my git config")
        expect(Dir).to exist(dotfiles_directory)
        expect(File).to be_symlink(abs_learn_path)
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

      context "for a cue that has been manually deleted from Sheldon's data directory" do
        it "should only delete the (broken) symlink on the user's filesystem" do
          FileUtils.rm_r(File.dirname(abs_brain_path))
          expect(File.exist?(abs_brain_path)).to be false

          expect(File.symlink?(abs_learn_path)).to be true
          brain.forget("my git config")
          expect(File.symlink?(abs_learn_path)).to be false
        end
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

  describe "#path_for_cue" do
    context "for a cue that exists in Sheldon's memory" do
      it "should return the brain path for a cue" do
        brain.learn("my git config", abs_learn_path)
        expect(brain.path_for_cue("my git config")).to eq(abs_brain_path)
      end
    end

    context "for a cue that doesn't exist in Sheldon's memory" do
      it "should raise a runtime exception" do
        expect{ brain.path_for_cue("lightbulb") }.to raise_error("no entry for cue 'lightbulb'")
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
