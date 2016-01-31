# coding: utf-8

source 'https://rubygems.org'
ruby "2.3.0"

gem 'rails', '4.2.5'
gem 'config' # 定数管理
gem 'haml-rails' # htmlテンプレート
gem 'sass-rails'
# gem 'compass-rails'
gem 'jquery-rails'            # jQury利用
gem 'uglifier'                # JavaScriptの圧縮
# gem 'coffee-rails'
gem 'twitter-bootstrap-rails'
gem 'turbolinks'
gem 'gon'                     # JavaScript連携
gem 'grape'                   # Restful API
gem 'unicorn'
gem 'therubyracer'
gem "font-awesome-rails"      # Font Awesome利用

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'sqlite3'
  gem 'better_errors'         # エラー画面の改良
  gem 'binding_of_caller'     # エラー画面にpry表示
  gem 'pry-rails'             # pry利用
  gem 'pry-byebug'            # pryでデバッグコマンドが可能
  gem 'hirb'                  # SQLの結果を整形
  # gem 'erb2haml'              # .erbを.hamlに変換
  # gem 'rails-erd'             # モデルのER図を出力
  # gem 'rails_best_practices'  # ベストプラクティスのチェック
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'rubocop', require: false
  gem 'brakeman', require: false
end
