require "spec_helper"

describe Memory do
  before(:each) { FileUtils.mkdir_p("spec/Users/test/sheldon") }
  after(:each) { FileUtils.rm_r("spec/Users") }

  let(:memory) { Memory.new("spec/Users/test/sheldon") }

  describe "#add" do
    context "when a cue has not previously been used" do
      it "should persist the new entry" do
        expect(memory.size).to eq 0
        memory.add("lightbulb", "moment")
        expect(memory.size).to eq 1
      end
    end

    context "when a cue has been previously used" do
      it "should raise an error" do
        memory.add("lightbulb", "moment")
        expect{ memory.add("lightbulb", "moment") }.to raise_error("cue already used")
      end
    end
  end


  describe "#recall" do
    context "when a cue does not exist in memory" do
      it "should raise an error" do
        expect{ memory.recall("lightbulb") }.to raise_error("no entry for cue")
      end
    end

    context "when a cue does exist in memory" do
      it "should return the value associated with that cue" do
        memory.add("lightbulb", "moment")
        expect(memory.recall("lightbulb")).to eq "moment"
      end
    end
  end


  describe "#has_cue" do
    context "when a cue is not saved in memory" do
      it "should return false" do
        expect(memory.has_cue?("lightbulb")).to be false
      end
    end

    context "when a cue is saved in memory" do
      it "should return true" do
        memory.add("lightbulb", "moment")
        expect(memory.has_cue?("lightbulb")).to be true
      end
    end
  end


  describe "#size" do
    it "should increase by 1 with each new entry" do
      expect{ memory.add("lightbulb", "moment") }.to change{ memory.size }.by(1)
    end
  end

  describe "#list_cues" do
    context "when the memory contains zero cues" do
      it "should return an empty list" do
        expect(memory.list_cues).to be_empty
      end
    end

    context "when memory contains multiple cues" do
      it "should return the cues" do
        memory.add("lightbulb", "moment")
        memory.add("rolo", "bounty")
        expect(memory.list_cues).to eq %w(lightbulb rolo)
      end
    end
  end

end
