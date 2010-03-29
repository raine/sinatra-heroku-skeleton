class Numeric
  def to_human
    units = %w{B KB MB GB TB}
    e = (Math.log(self)/Math.log(1024)).floor
    s = "%.2f" % (to_f / 1024**e)
    s.sub(/\.?0*$/, units[e])
  end
end

MIN_JAR = "java -jar closure-compiler.jar"
JS_DIR  = "public/javascripts"
SRC_MIN = "#{JS_DIR}/application.min.js"

# JavaScript files to minify, also determines the order in the minified file
# JS_FILES = [
#   "hello.js",
#   "world.js"
# ]

JS_FILES = []

task :minify do
  files = JS_FILES.map { |file| "--js=#{JS_DIR}/#{file}" }.join(" ")
  sh "#{MIN_JAR} #{files} --warning_level QUIET > #{SRC_MIN}"
end

task :report do
  unminified_size = JS_FILES.map do |f|
    size = File.size?("#{JS_DIR}/#{f}")
    puts "#{f.ljust(JS_FILES.map { |e| e.size }.max)} | #{size.to_human}"
    size
  end.inject(0) { |s, n| s + n }
  minified_size   = File.size?(SRC_MIN)
  saved = unminified_size - minified_size

  puts
  puts "#{unminified_size.to_human} → #{minified_size.to_human}"
  puts "Saved #{saved.to_human} (#{"%.2f" % ((1 - minified_size/unminified_size.to_f) * 100)}%)"
end

task :default => [:minify, :report]

task :deploy, [:commit] do |t, args|
  args.with_defaults(:commit => "HEAD")

  sh "git tag deploy-#{Time.now.strftime("%Y%m%d%H%M")} #{args.commit}"
  sh "git branch -D deploy; true"
  sh "git checkout -b deploy #{args.commit}"
  unless JS_FILES.empty?
    Rake::Task[:default].invoke
    sh "git add #{SRC_MIN}"
    sh "git commit -m 'Minify JS'; true"
  end
  sh "git push -f heroku deploy:master"
  sh "git checkout master"
end
