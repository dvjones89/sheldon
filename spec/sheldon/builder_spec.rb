require "spec_helper"

describe Builder do

  before(:each) do
    FileUtils.rm_r("spec/Users") if Dir.exist?("spec/Users")
    FileUtils.mkdir_p("spec/Users/test")
  end

  after(:each) do
    FileUtils.rm_r("spec/Users")
  end

  let(:builder) { Builder.new }
  let(:abs_home_path) { abs("spec/Users/test") }
  let(:abs_master_path) { abs("spec/Users/test/config") }

  describe "build" do
    context "for a directory with no config_ files" do
      it "should not create a master config file" do
        expect(builder.build(abs_home_path)).to be false
        expect(File).not_to exist(abs_master_path)
      end
    end

    context "for a directory with multiple config_ files" do
      it "should create a master config file" do
        File.write(File.join(abs_home_path, "config_1"), "hello")
        File.write(File.join(abs_home_path, "config_2"), "world")
        expect(builder.build(abs_home_path)).to be true
        expect(File.read(abs_master_path)).to eq "hello\nworld\n"
      end
    end
  end

end
