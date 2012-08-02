FAYE_DOMAIN = if Rails.env == 'production'
                'http://payback.io'
              else
                'http://localhost:9292'
              end
