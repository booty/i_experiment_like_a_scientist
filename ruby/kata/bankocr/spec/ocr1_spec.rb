# spec/ocr_spec.rb
# frozen_string_literal: true

RSpec.describe Ocr do
  describe ".validate_normalized_lines" do
    context "when input is valid" do
      it "does not raise" do
        input = "abcdef\nghijkl\nmnopqr\n"
        expect { described_class.validate_normalized_lines!(input) }.not_to raise_error
      end
    end

    context "when stripped line lengths are not all equal" do
      it "raises MalformedInput with the expected message" do
        input = "abcdef\nabcde\nabcdef\n"
        expect { described_class.validate_normalized_lines!(input) }
          .to raise_error(Ocr::MalformedInput, "All lines of text should be the same length")
      end
    end

    context "when line lengths differ only because of leading/trailing whitespace" do
      it "does not raise (sanity check)" do
        input = "abcdef \nabcdef\n abcdef\n"
        expect { described_class.validate_normalized_lines!(input) }.not_to raise_error
      end
    end

    context "when input is not 3 lines long" do
      context "when fewer than 3 lines" do
        it "raises MalformedInput with the expected message" do
          input = "abc\babc"
          expect { described_class.validate_normalized_lines!(input) }
            .to raise_error(Ocr::MalformedInput, "Input should be 3 lines long")
        end
      end

      context "when more than 3 lines" do
        it "raises MalformedInput with the expected message" do
          input="abc\nabc\n\abc\nabc"
          expect { described_class.validate_normalized_lines!(input) }
            .to raise_error(Ocr::MalformedInput, "Input should be 3 lines long")
        end
      end
    end

    context "when the first line length is not a multiple of 3" do
      it "raises MalformedInput with the expected message" do
        input = "aaaa\nbbbb\ncccc"
        expect { described_class.validate_normalized_lines!(input) }
          .to raise_error(Ocr::MalformedInput, "Each line length should be a multiple of 3")
      end
    end

  end
end
