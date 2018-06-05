require 'pieces_lib/king'

describe King do
  before(:each) { @myboard = Board.new }
  describe ".king_legal_moves" do
    before(:each) { @myboard.board[3][3] = King.new(3,3) }
    context "given normal case (no pieces intervene)" do

      before { @myboard.select 'd4' }

      it "returns correct positions" do
        expect(@myboard.selected.king_legal_moves).to eql()
      end
    end

    context "given the same color pawn blocking one position" do
      before do 
        @myboard.board[3][4] = Pawn.new(4,3)
        @myboard.select 'd4'
      end
      it "returns correct 7 positions" do
        expect(@myboard.selected.king_legal_moves).to eql()
      end
    end
    context "given"
  end
end