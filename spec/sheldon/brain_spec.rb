require 'spec_helper'

describe Brain do

  let(:brain) { Brain.new("/Users/test/sheldon") }

  describe '#learn' do
    it "should move the target file/folder into Sheldon's brain" do
      FileUtils.expects(:mkdir_p).with("/Users/test/sheldon/my git config").once
      FileUtils.expects(:mv).with("~/.gitconfig", "/Users/test/sheldon/my git config").once

      brain.learn("my git config", "~/.gitconfig")
    end
  end

  describe "#recall" do
    it "should symlink from Sheldon's brain back to the original file-system location" do
      brain.stubs(:read_synapse).returns("/Users/test/sheldon/my git config/.gitconfig")

      FileUtils.expects(:ln_s).with("/Users/test/sheldon/my git config/.gitconfig", "~/.gitconfig").once

      brain.recall('my git config', '~/.gitconfig')
      
    end
  end

end
