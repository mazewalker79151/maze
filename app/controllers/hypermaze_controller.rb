class HypermazeController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
    end

    def generate
      maze = Hypermaze.new(params[:rows], params[:cols], params[:planes])
      maze.generate
      maze.solve
      render :json => { :maze => maze.maze } and return
    end

end
