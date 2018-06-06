require "spec_helper.rb"
require "chess_board"

describe King do

  before(:each) { @myboard = Board.new }
  before(:each) { @myboard.board[3][3] = King.new(3,3) }
  describe ".king_legal_moves" do

    context "given normal case (no pieces intervene)" do

      before { @myboard.select 'd4' }

      it "returns correct positions" do
        expect(@myboard.selected.king_legal_moves).to eql([[3, 4], [3, 2], [4, 4], [4, 2], [4, 3], [2, 4], [2, 2], [2, 3]])
      end
    end

    context "given the same color pawn blocking one position" do

      before do
        @myboard.board[3][4] = Pawn.new(4,3)
        @myboard.select 'd4'
      end

      it "returns correct 7 positions" do
        expect(@myboard.selected.king_legal_moves).to eql([[3, 4], [3, 2], [4, 4], [4, 2], [2, 4], [2, 2], [2, 3]])
      end

    end

    context "when a bishop is blocking the move" do

      before do
        @myboard.board[5][4] = Bishop.new(4,5,'b')
        @myboard.select 'd4'
      end

      it "returns correct positions (not allowed to move to check)" do
        expect(@myboard.selected.king_legal_moves).to eql([[3, 2], [4, 4], [4, 2], [4, 3], [2, 4], [2, 2]])
      end
    end

    context "when in check" do

      before do 
        @myboard.board[5][5] = Bishop.new(5,5,'b')
        @myboard.select 'd4'
      end

      it "cannot move into check again" do
        expect(@myboard.selected.king_legal_moves).to eql([[3, 4], [3, 2], [4, 2], [4, 3], [2, 4], [2, 3]])
      end
    end

    context "when Rook and Queen blocking the moves" do

      before do 
        @myboard.board[5][5] = Bishop.new(5,5,'b')
        @myboard.board[5][3] = Rook.new(3,5,'b')
        @myboard.select 'd4'
      end

      it "cannot move into check again" do
        expect(@myboard.selected.king_legal_moves).to eql([[4, 2], [4, 3], [2, 4], [2, 3]])
      end
    end

    context "when checkmate" do

      before do
        @myboard.board[5][5] = Bishop.new(5,5,'b')
        @myboard.board[5][3] = Rook.new(3,5,'b')
        @myboard.board[5][2] = Rook.new(2,5,'b')
        @myboard.board[0][5] = Knight.new(5,0,'b')
        @myboard.board[4][5] = Pawn.new(5,4,'b')
        @myboard.select 'd4'
      end

      it "returns empty array" do
        expect(@myboard.selected.king_legal_moves).to eql([])
      end
    end
  end

  describe ".king_capture_moves" do

    context "given normal case" do

      before do
        @myboard.board[3][4] = Pawn.new 4,3,'b'
        @myboard.select 'd4'
      end

      it "retuns the correct position" do
        expect(@myboard.selected.king_capture_moves).to eql([[4,3]])
      end
    end

    context "given a move that will lead to being in check" do

      before do
        @myboard.board[3][4] = Pawn.new 4,3,'b'
        @myboard.board[4][5] = Pawn.new 5,4,'b'
        @myboard.select 'd4'
      end

      it "returns empty array (ignores the capture move)" do
        expect(@myboard.selected.king_capture_moves).to eql([])
      end
    end

    context "given multiple capture options" do

      before do
        @myboard.board[3][4] = Pawn.new 4,3,'b'
        @myboard.board[3][2] = Pawn.new 2,3,'b'
        @myboard.select 'd4'
      end

      it "returns 2 positions" do
        expect(@myboard.selected.king_capture_moves).to eql([[4, 3], [2, 3]])
      end
    end
  end
end