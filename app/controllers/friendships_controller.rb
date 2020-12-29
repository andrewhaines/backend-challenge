class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:update, :destroy]

  def new
    @friendship = Friendship.new
  end

  def create
    @friendship = Friendship.new(friendship_params)

    respond_to do |format|
      if @friendship.save
        format.html { redirect_to member_path(@friendship.member), notice: 'Friendship was successfully created.' }
        format.json { render :show, status: :created, location: @friendship }
      else
        format.html { render :new }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @friendship.destroy
    respond_to do |format|
      format.html { redirect_back(fallback_location: member_path(@friendship.member), notice: 'Friendship was successfully destroyed.') }
      format.json { head :no_content }
    end
  end

  private
    def set_friendship
      @friendship = Friendship.find(params[:id])
    end

    def friendship_params
      params.require(:friendship).permit(:member_id, :friend_id)
    end
end
