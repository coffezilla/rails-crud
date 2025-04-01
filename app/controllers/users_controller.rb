class UsersController < ApplicationController
    # Skip CSRF for API
    # skip_before_action :verify_authenticity_token, only: [:create, :login]
    before_action :authenticate_user!, only: [:index, :show, :update, :destroy]

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
        # Generate tokens
        access_token = generate_access_token(user)
        refresh_token = generate_refresh_token(user)

        render json: { access_token: access_token, refresh_token: refresh_token, user: user }, status: :ok
    else
        render json: { error: "Invalid email or password" }, status: :unauthorized
      end
    end
  
    # Refresh access token
    def refresh_token
        begin
            decoded_token = JWT.decode(params[:refresh_token], Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
            user_id = decoded_token[0]['user_id']
            user = User.find(user_id)
        
            # Generate a new access token
            new_access_token = generate_access_token(user)
        
            render json: { access_token: new_access_token }, status: :ok
        rescue JWT::DecodeError
            render json: { error: "Invalid refresh token" }, status: :unauthorized
        end
    end
  
    private
  
      # Authenticate user using JWT
    def authenticate_user!
            token = request.headers['Authorization']&.split(' ')&.last
        begin
            decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
            @current_user = User.find(decoded_token[0]['user_id'])
        rescue JWT::DecodeError
            render json: { error: "Unauthorized" }, status: :unauthorized
        end
    end

    # Permit parameters without requiring user key
    def user_params
      params.permit(:name, :email, :password)
    end

    # Generate JWT access token
    def generate_access_token(user)
        # payload = { user_id: user.id, exp: 5.seconds.from_now.to_i }
        payload = { user_id: user.id, exp: 1.hour.from_now.to_i }
        JWT.encode(payload, Rails.application.credentials.secret_key_base) 
    end

    # Generate refresh token (a simple approach)
    def generate_refresh_token(user)
        # payload = { user_id: user.id, exp: 15.seconds.from_now.to_i }
        payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
        JWT.encode(payload, Rails.application.credentials.secret_key_base)
    end
        
  end