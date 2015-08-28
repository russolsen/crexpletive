require "./spec_helper"

describe Expletive do
  describe Expletive::Dump do
    it "passes text unchanged" do
      input = "hello world"
      input.should eq(endump(input))
    end

    it "passes empty strings unchanged" do
      input = ""
      input.should eq(endump(input))
    end

    it "encodes binary into hex" do
      input = "\01\02\03xyz"
      "\\01\\02\\03xyz".should eq(endump(input))
    end

    it "escapes backslashes" do
      input = "abc\\def"
      "abc\\\\def".should eq(endump(input))
    end

    it "escapes newlines" do
      input = "abc\ndef"
      "abc\\ndef".should eq(endump(input))
    end
  end

  describe Expletive::Undump do
    describe "#run" do
      it "passes text unchanged" do
        input = "hello world"
        input.should eq(dedump(input))
      end

      it "leaves empty strings as is" do
        input = ""
        input.should eq(dedump(input))
      end


      it "decodes hex into equivalent binary" do
        input = "\\01\\02\\03xyz"
        output = "\01\02\03xyz"
        output.should eq(dedump(input))
      end

      it "turns backslash backslash into a single backslash" do
        input = "abc\\\\def"
        output = "abc\\def"
        output.should eq(dedump(input))
      end

      it "turns backslash n into a real newline" do
        input = "abc\\ndef"
        output = "abc\ndef"
        output.should eq(dedump(input))
      end
    end
  end

  describe "RoundTrip" do
    it "converts conveys random strings without changing them" do
      5000.times do
        input = random_string(300)
        output = round_trip(input)
        input.should eq(output)
      end
    end
  end
end
