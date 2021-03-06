require "spec_helper"

describe Memory do
  before(:each) { FileUtils.mkdir_p("spec/Users/test/sheldon") }
  after(:each) { FileUtils.rm_r("spec/Users") }

  let(:memory) { Memory.new("spec/Users/test/sheldon") }

  describe "#add" do
    context "when a cue has not previously been used" do
      it "should persist the new entry" do
        expect(memory.size).to eq 0
        memory.add("lightbulb", {filepath: "/path/to/lightbulb"})
        expect(memory.size).to eq 1
      end
    end

    context "when a cue has been previously used" do
      it "should raise an error" do
        memory.add("lightbulb", {filepath: "/path/to/lightbulb"})
        expect{ memory.add("lightbulb", {filepath: "/path/to/lightbulb"}) }.to raise_error("cue already used")
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
        memory.add("lightbulb", {filepath: "/path/to/lightbulb"})
        expect(memory.has_cue?("lightbulb")).to be true
      end
    end
  end

  describe "#forget" do
    context "when a cue does not exist in memory" do
      it "should raise an error" do
        expect{ memory.recall("lightbulb") }.to raise_error("no entry for cue 'lightbulb'")
      end
    end

    context "when a cue does exist in memory" do
      before(:each) { memory.add("lightbulb", {filepath: "/path/to/lightbulb"}) }

      it "should remove the entry from the database" do
        expect(memory.has_cue?("lightbulb")). to be true
        memory.forget("lightbulb")
        expect(memory.has_cue?("lightbulb")). to be false
      end
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
        memory.add("rolo", {filepath: "/path/to/rolo"})
        memory.add("bounty", {filepath: "/path/to/bounty"})
        expect(memory.list_cues).to eq ['rolo','bounty']
      end
    end
  end

  describe "#save!" do
    it "should write Sheldon's memory to local storage" do
      expect(File).not_to exist("spec/Users/test/sheldon/db.yml")
      memory.save!
      expect(File).to exist("spec/Users/test/sheldon/db.yml")
    end
  end

  describe "#present?" do
    context "when memory hasn't been persisted to storage" do
      it "should return false" do
        expect(memory.present?).to be false
      end
    end

    context "when memory has been saved to storage" do
      it "should return true" do
        memory.save!
        expect(memory.present?).to be true
      end
    end
  end

  describe "#recall" do
    context "when a cue does not exist in memory" do
      it "should raise an error" do
        expect{ memory.recall("lightbulb") }.to raise_error("no entry for cue 'lightbulb'")
      end
    end

    context "when a cue does exist in memory" do
      it "should return the value associated with that cue" do
        memory.add("lightbulb", {filepath: "/path/to/lightbulb"})
        expect(memory.recall("lightbulb")).to eq ({filepath: "/path/to/lightbulb"})
      end
    end
  end


  describe "#size" do
    it "should increase by 1 with each new entry" do
      expect{ memory.add("lightbulb", {filepath: "/path/to/lightbulb"}) }.to change{ memory.size }.by(1)
    end
  end

end
