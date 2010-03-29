configure :development do
  set :js_minified, false
end

configure :production do
  set :js_minified, true
end
