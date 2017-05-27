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

  let(:brain) { Brain.new("spec/Users/test/sheldon") }
  let(:builder) { Builder.new }
  let(:sheldon) { Sheldon.new("spec/Users/test/sheldon", brain: brain, builder: builder) }
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


  describe "#build" do
    it "should delegate to Builder#build" do
      expect(builder).to receive(:build).once.with(abs_home_path)
      sheldon.build(abs_home_path)
    end
  end

  describe "#learn" do
    context "for a new cue that does not exist in Sheldon's memory" do
      it "should delegate to the appropriate methods on Sheldon's brain" do
        abs_learn_path = File.expand_path("spec/Users/test/.gitconfig")
        expect(brain).to receive(:learn).once.with("my git config", abs_learn_path)
        sheldon.learn("my git config", abs_learn_path)
      end
    end

    context "for a cue that already exists in Sheldon's memory" do
      it "should raise an error" do
        sheldon.learn("my git config", abs_learn_path)
        expect{ sheldon.learn("my git config", abs_learn_path) }.to raise_error("This cue has already been used.")
      end
    end

    context "for an empty cue" do
      it "should raise an error" do
        expect{ sheldon.learn(" ", abs_learn_path) }. to raise_error("recall cue cannot be empty.")
      end
    end
  end

  describe "#recall" do
    context "for a cue that exists in Sheldon's memory" do
      it "should delegate to the appropriate methods on Sheldon's brain" do
        sheldon.learn("my git config", abs_learn_path)
        expect(brain).to receive(:recall).once.with("my git config")
        sheldon.recall("my git config")
      end
    end

    context "for a cue that does not exist in Sheldon's memory" do
      it "should raise an error" do
        expect{ sheldon.recall("lightbulb") }.to raise_error("Cue 'lightbulb' could not be found.")
      end
    end
  end

  describe "#forget" do
    context "for a cue that does not exist in Sheldon's memory" do
      it "should raise an error" do
        expect{ sheldon.forget("lightbulb") }.to raise_error("Cue 'lightbulb' could not be found.")
      end
    end

    context "for a cue that exists in Sheldon's memory" do
      before(:each) { sheldon.learn("my git config", abs_learn_path) }

      it "should delegate to the appropriate methods on Sheldon's brain" do
        expect(brain).to receive(:forget).once.with("my git config")
        sheldon.forget("my git config")
      end
    end

  end

  describe "#recalled?" do
    context "for a cue that does not exist in Sheldon's memory" do
      it "should raise an error" do
        expect{ sheldon.recalled?("lightbulb") }.to raise_error("Cue 'lightbulb' could not be found.")
      end
    end

    context "for a cue that does exist in Sheldon's memory" do
      it "should delegate to the appropriate methods on Sheldon's brain" do
        sheldon.learn("my git config", abs_learn_path)
        expect(brain).to receive(:recalled?).once
        sheldon.recalled?("my git config")
      end
    end
  end

  describe "#list_cues" do
    it "should delegate to Brain#list_cues" do
      expect(brain).to receive(:list_cues).once
      sheldon.list_cues
    end
  end

end
