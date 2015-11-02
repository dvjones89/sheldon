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
  let(:sheldon) { Sheldon.new("spec/Users/test/sheldon", brain) }

  describe "#learn" do
    context "for a new cue that does not exist in Sheldon's memory" do
      it "should call the appropriate method(s) on Sheldon's brain" do
        abs_learn_path = File.expand_path("spec/Users/test/.gitconfig")
        expect(brain).to receive(:learn).once.with("my git config", abs_learn_path)
        expect(brain).to receive(:recall).once.with("my git config")
        sheldon.learn("my git config", "spec/Users/test/.gitconfig")
      end
    end

    context "for a cue that already exists in Sheldon's memory" do
      it "should raise an error" do
        sheldon.learn("my git config", "spec/Users/test/.gitconfig")
        expect{ sheldon.learn("my git config", "spec/Users/test/.gitconfig") }.to raise_error("This cue has already been used.")
      end
    end
  end

  describe "#recall" do
    context "for a cue that exists in Sheldon's memory" do
      it "should call the appropriate method(s) on Sheldon's brain" do
        sheldon.learn("my git config", "spec/Users/test/.gitconfig")
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

  describe "#list" do
    it "should delegate to memory#list" do
      expect(brain).to receive(:list).once
      sheldon.list
    end
  end

end
