# encoding: UTF-8
# 男:1/女:1 入室したらカウンタ表示される初期条件
room = Room.create
room.users.create(name: 'user01', gender: 'male')
room.users.create(name: 'user02', gender: 'female')
room.create(male: 1, female: 1)
