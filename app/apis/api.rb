class API < Grape::API
  prefix "api"
  version 'v1', using: :path

  resource "user" do
    desc "registers window_id to User"
    # Register window_id on User Table: /api/v1/user
    # Try below command on your terminal. if you get result true, it must be sccuess
    # $ curl -X PUT /api/v1/user/1 -d "window_id=test2"
    params do
      requires :user_id, type: Integer
      requires :window_id, type: String
    end
    put ':user_id' do
      user = User.find_by_id(params[:user_id])
      if user.present?
        return { result: true } if user.update(window_id: params[:window_id])
      end
      return { result: false }
    end
  end

  resource "users" do
    desc "returns users in the room"
    # Users in the room API: /api/v1/users/:room_id
    params do
      requires :room_id, type: Integer
    end
    get ':room_id' do
      return User.where(room_id: params[:room_id])
    end
  end

  resource "window_id" do
    desc "gets User information with window_id and room_id"
    # /api/v1/window_id/:window_id?room_id=:room_id
    params do
      requires :window_id, type: String
      requires :room_id, type: Integer
    end
    get ':window_id' do
      user = User.find_by(window_id: params[:window_id], room_id: params[:room_id])
      return { result: false } if user.nil?
      return user
    end
  end

  resource "leaving_user" do
    desc "change to invalids status with User"
    # $ curl -X PUT curl -X PUT api/v1/leaving_user -d "user_id=:user_id"
    params do
      requires :user_id, type: String
    end

    put do
      user = User.find_by_id params[:user_id]
      return { result: true } if user.present? && user.update(status: false)
      return { result: false }
    end
  end

  resource "room_full" do
    # Room Full API: /api/v1/room_full/:room_id
    desc "returns True when four member joined in the room"
    params do
      requires :room_id, type: Integer
    end
    get ':room_id' do
      room = Room.find_by_id(params[:room_id])
      return { result: false } if room.nil?
      case room.status
      when 1
        return { result: false }
      when 2, 3
        return { result: true, time: room.updated_at.to_s }
      else
        return { result: false }
      end
    end
  end
end
