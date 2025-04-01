class UsersController < ApplicationController
    # Skip CSRF for API
    # skip_before_action :verify_authenticity_token, only: [:create, :login]
  
    # Create a new user
    def create
      user = User.new(user_params)
  
      if user.save
        render json: user, status: :created
      else
        render json: user.errors, status: :unprocessable_entity
      end
    end
  
    # Show all users
    def index
      users = User.all
      render json: users
    end
  
    # Show user details
    def show
      user = User.find(params[:id])
      render json: user
    end
  
    # Update user details
    def update
      user = User.find(params[:id])
  
      if user.update(user_params)
        render json: user
      else
        render json: user.errors, status: :unprocessable_entity
      end
    end
  
    # Delete a user
    def destroy
      user = User.find(params[:id])
      user.destroy
      head :no_content
    end
  
    # User login
    def login
      user = User.find_by(email: params[:email])
  
      if user&.authenticate(params[:password])
        render json: { message: "Login successful", user: user }, status: :ok
      else
        render json: { error: "Invalid email or password" }, status: :unauthorized
      end
    end
  
    private
  
    # Permit parameters without requiring user key
    def user_params
      params.permit(:name, :email, :password)
    end
  end