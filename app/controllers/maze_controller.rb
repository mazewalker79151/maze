class MazeController < ApplicationController

    before_action :get_maze, :except => :index
    skip_before_action :verify_authenticity_token

    def index

    end


    def validate
      begin
        check = Validator.new( @maze )
        render :json => { :valid => check.is_valid } and return
      rescue
        render :json => { :valid => false } and return
      end
    end

    def solve
      solver = Solver.new( @maze )
      logger.info solver.get_solution.to_json
      render :json => { :maze => solver.get_solution } and return
    end

protected
    def get_maze
    	@maze = params[:maze]
    end

end
