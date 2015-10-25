require 'spec_helper'

describe Brain do

  describe '#learn', memfs: true do

    it "should move the target file/folder into Sheldon's brain" do
      brain = Brain.new("~/sheldon")
      brain.learn("my git config", "~/.gitconfig")
      expect(File.exist?("~/sheldon/my git config/.gitconfig")).to eq true
    end

  end

end
