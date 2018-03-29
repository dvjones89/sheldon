require "spec_helper"

describe Sheldon do

  before(:each) do
    FileUtils.rm_r("spec/Users") if Dir.exists?("spec/Users")
    FileUtils.mkdir_p("spec/Users/test/sheldon")
    FileUtils.touch("spec/Users/test/.gitconfig")
  end

  after(:each) do
    FileUtils.rm_r("spec/Users")
  end

  let(:sheldon) { Sheldon.new("spec/Users/test/sheldon") }
  let(:abs_home_path) { abs("spec/Users") }
  let(:abs_learn_path) { abs("spec/Users/test/.gitconfig") }

  describe "#initialize" do
    context "passing a data directory that doesn't exist" do
      it "should raise an exception" do
        expect { Sheldon.new("incorrect_path") }.to raise_error(MissingDataDirectoryException)
      end
    end

    context "passing a data directory" do
      it "should create a new Sheldon instance" do
        expect(Sheldon.new("spec/Users/test/sheldon")).to be_a Sheldon
      end
    end
  end

  # Smoke-test
  describe "#build" do
    context "for a directory with 2 config_ files" do
      it "should build a master config file successfully" do
        File.write(File.join(abs_home_path, 'config_1'), 'hello')
        File.write(File.join(abs_home_path, 'config_2'), 'world')
        expect(sheldon.build(abs_home_path)).to be true
      end
    end
  end

  # Smoke-test
  describe "#forget" do
    context "for a cue that exists in Sheldon's memory" do
      it "should forget the cue successfully" do
        sheldon.learn("my git config", abs_learn_path)
        expect(sheldon.forget("my git config")).to be true
      end
    end
  end

  # Smoke-test
  describe "#learn" do
    context "for a new cue that does not exist in Sheldon's memory" do
      it "should learn the new cue successfully" do
        expect(sheldon.learn("my git config", abs_learn_path)).to be true
      end
    end
  end

  # Smoke-test
  describe "#list_cues" do
    it "should respond with the list of learned cues" do
      sheldon.learn("my git config", abs_learn_path)
      expect(sheldon.list_cues).to eq ["my git config"]
    end
  end

  # Smoke-test
  describe "#recall" do
    context "for a cue that exists in Sheldon's memory" do
      it "should successfully recall the cue" do
        sheldon.learn("my git config", abs_learn_path)
        expect(sheldon.recall("my git config")).to be true
      end
    end
  end

  # Smoke-test
  describe "#setup!" do
    it "should create a new brain on the local file-system" do
      allow_any_instance_of(Helpers).to receive(:add_home).and_return("spec/Users/test/.sheldon")

      expect(sheldon.brain.present?).to be false
      sheldon.setup!
      expect(sheldon.brain.present?).to be true
    end
  end

  # Smoke-test
  describe "#recalled?" do
    context "for a cue that has been recalled" do
      it "should return true" do
        sheldon.learn("my git config", abs_learn_path)
        expect(sheldon.recall("my git config")).to be true
      end
    end
  end

end
