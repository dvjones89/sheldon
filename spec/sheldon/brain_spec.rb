require 'spec_helper'

describe Brain do

  describe '#learn' do

    it "should move the target file/folder into Sheldon's brain" do
      brain = Brain.new("/Users/test/sheldon")
      brain.stubs(:read_synapse).returns("/Users/test/sheldon/my git config/.gitconfig")

      FileUtils.expects(:mkdir_p).with("/Users/test/sheldon/my git config").once
      FileUtils.expects(:mv).with("~/.gitconfig", "/Users/test/sheldon/my git config").once
      FileUtils.expects(:ln_s).with("/Users/test/sheldon/my git config/.gitconfig", "~/.gitconfig").once

      brain.learn("my git config", "~/.gitconfig")
    end

  end

end
