module Trestle
  class Engine < ::Rails::Engine
    isolate_namespace Trestle

    # Application assets
    config.assets.precompile << "trestle/admin.css" << "trestle/admin.js"

    # Vendor assets
    config.assets.precompile << %r(trestle/bootstrap-sass/assets/fonts/bootstrap/glyphicons-halflings-regular\.(?:eot|svg|ttf|woff|woff2)$)
    config.assets.precompile << %r(trestle/font-awesome/fonts/fontawesome-webfont\.(?:eot|svg|ttf|woff|woff2)$)

    # Optional turbolinks
    config.assets.precompile << "turbolinks.js" if defined?(Turbolinks)
  end
end
