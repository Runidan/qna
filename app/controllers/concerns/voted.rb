module  Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down, :unvote]

    def vote_up
     if current_user.can_vote_for?(@votable)
        @votable.vote_up_by(current_user) 
        render json: {id: @votable.id, rating: @votable.rating, voted: true }, status: :ok
      else
        render json: { error: "You can't vote for your own post or vote twice." }, status: :forbidden
      end
    end
    
    def vote_down
      if current_user.can_vote_for?(@votable)
        @votable.vote_down_by(current_user) 
        render json: {id: @votable.id, rating: @votable.rating, voted: true }, status: :ok
      else
        render json: { error: "You can't vote for your own post or vote twice." }, status: :forbidden
      end
    end

    def unvote
      vote = current_user.votes.find_by(votable: @votable)
      if vote
        vote.destroy
        render json: {id: @votable.id, rating: @votable.rating, voted: false }, status: :ok
      else
        render json: { error: "You haven't voted for this." }, status: :not_found
      end
    end

    private

    def set_votable
      votable_type = votable_type_from_path
      votable_id = params[:id]
      @votable = votable_type.constantize.find(votable_id)
     end

    def votable_type_from_path
      request.path.split('/')[1].singularize.capitalize
    end
  end
  
end