require "spec_helper"

describe Helpers do
  describe "#with_exception_handling" do
    it "should execute healthy without any drama" do
      expect(with_exception_handling{1+1}).to eq(2)
    end


    context "When an exception has been encountered" do
      before(:each) do
        @exception = Exception.new("This is a test exception")
        @exception.set_backtrace(caller)
      end

      context "when debug_file_path hasn't been set in Sheldon's .dotfile" do
        it "should print the error message to the console in red text" do
          allow(subject).to receive(:red)
          subject.with_exception_handling{raise @exception}
          expect(subject).to have_received(:red).with(@exception.message)
        end
      end

    end
  end
end
