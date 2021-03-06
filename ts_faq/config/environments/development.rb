TsFaq::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # アプリケーションクラスのリロードをするかの設定
  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # 初期化されていないオブジェクトの警告
  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  # エラー情報をブラウザに表示をするかの設定（開発のデフォルトはtrue）
  config.consider_all_requests_local       = true
  # コントローラのキャッシュ設定をするかの設定
  config.action_controller.perform_caching = false

  # 電子メールが配信完了できない場合にエラーを発生させるかの設定
  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Assetの結合と圧縮の設定
  # Expands the lines which load the assets
  config.assets.debug = true

  # ログローテーションの設定（10MBを超えるとファイル作成、10ファイル以上は削除）
  config.logger = Logger.new(config.paths["log"].first, 10, 10 * 1024 * 1024)
  # ログレベルの設定（すべて表示）
  config.logger.level = Logger::DEBUG
  # ログに日時を追加
  config.logger.formatter = Logger::Formatter.new
  config.logger.datetime_format = "%Y-%m-%d %H:%M:%S"
end
