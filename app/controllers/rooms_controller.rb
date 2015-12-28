class RoomsController < ApplicationController
  before_action :set_user, only: [:room, :vote]

  # GET /
  def index
  end

  # POST /casting
  def casting
    room = nil
    if params[:gender] == 'male'
      room = Room.find_by("male < #{Settings.room.capacity}")
    else
      room = Room.find_by("female < #{Settings.room.capacity}")
    end
    if room.nil?
      room = Room.new(male: 0, female: 0)
    end

    if params[:gender] == 'male'
      room.male += 1
    else
      room.female += 1
    end
    room.save

    @user = room.users.new(
      name: params[:name],
      gender: params[:gender]
    )
    @user.save

    redirect_to :action => "room", :id => @user.id
  end

  # GET /room/1
  def room
    gon.user = @user
  end

  # GET /vote/1
  def vote
    room = @user.room

    @candidates = Array.new
    if @user.gender == 'male'
      @candidates = room.users.where(gender: 'female')
    else
      @candidates = room.users.where(gender: 'male')
    end
  end

  # POST /matching
  def matching
    my_id = params[:user][:id]
    vote_id = params[:candidate]
    room_id = ((0..9).to_a + ("a".."z").to_a + ("A".."Z").to_a).sample(Settings.match.roomid_num).join

    match1 = Match.create(
      my_id: my_id,
      vote_id: vote_id,
      room_id: room_id
    )

    # 投票待ち
    sleep(Settings.match.vote_time)

    match2 = Match.find_by(my_id: vote_id, vote_id: my_id)
    if match2.nil?
      # not match
      redirect_to :action => "index"
    else
      # match
      @room_id = (my_id > vote_id) ? match1.room_id : match2.room_id
      redirect_to :action => "message", :id => @room_id
    end
  end

  # GET /message/1
  def message
  end

  private
  def set_user
    @user = User.find_by_id(params[:id])
    redirect_to :action => "index" if @user.nil?
  end

end
