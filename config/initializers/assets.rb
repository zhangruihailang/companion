# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( foundation/foundation.css )
Rails.application.config.assets.precompile += %w( vendor/modernizr.js )
Rails.application.config.assets.precompile += %w( vendor/jquery.js )
Rails.application.config.assets.precompile += %w( foundation/foundation.js )
Rails.application.config.assets.precompile += %w( foundation/foundation.offcanvas.js )
#Rails.application.config.assets.precompile += %w( foundation/foundation.min.js )
Rails.application.config.assets.precompile += %w( foundation/foundation.tab.js )
Rails.application.config.assets.precompile += %w( foundation/foundation.clearing.js )
Rails.application.config.assets.precompile += %w( foundation/foundation.orbit.js )
Rails.application.config.assets.precompile += %w( foundation/normalize.css )
Rails.application.config.assets.precompile += %w( app.css )
Rails.application.config.assets.precompile += %w( footer.js )
Rails.application.config.assets.precompile += %w( circliful.css )
Rails.application.config.assets.precompile += %w( circliful.js )
Rails.application.config.assets.precompile += %w( jquery-plugin-circliful/jquery.circliful.css )
Rails.application.config.assets.precompile += %w( jquery-plugin-circliful/jquery.circliful.js )
Rails.application.config.assets.precompile += %w( main.css )
Rails.application.config.assets.precompile += %w( base.css )
Rails.application.config.assets.precompile += %w( load-awesome/loaders.css )
Rails.application.config.assets.precompile += %w( load-awesome/style.css )