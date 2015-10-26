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

  let(:sheldon) { Sheldon.new }

  describe "#learn" do
    context "for a recall_cue that exists in Sheldon's memory" do
      it "should call Brain#learn and Brain#link" do
        abs_learn_path = File.expand_path("spec/Users/test/.gitconfig")
        expect(sheldon.send(:brain)).to receive(:learn).once.with("my git config", abs_learn_path)
        expect(sheldon.send(:brain)).to receive(:recall).once.with("my git config")
        sheldon.learn("my git config", "spec/Users/test/.gitconfig")
      end
    end
  end
end
