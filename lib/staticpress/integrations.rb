if defined? Sass
  theme_name = Staticpress::Configuration.instance.theme

  sass_paths = [
    (Staticpress.blog_path + 'themes' + theme_name + 'assets' + 'styles'),
    (Staticpress.root + 'themes' + theme_name + 'assets' + 'styles')
  ]

  sass_paths << Compass.sass_engine_options[:load_paths] if defined? Compass

  (sass_paths.flatten - Sass.load_paths).each do |path|
    Sass.load_paths << path
  end
end
