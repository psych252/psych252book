require 'html-proofer'
require 'html/pipeline'
require 'find'

# make an out dir
# Dir.mkdir("out") unless File.exist?("out")

# pipeline = HTML::Pipeline.new [
#   HTML::Pipeline::MarkdownFilter,
#   HTML::Pipeline::TableOfContentsFilter
# ], :gfm => true

# # iterate over files, and generate HTML from Markdown
# Find.find("./docs") do |path|
#   if File.extname(path) == ".md"
#     contents = File.read(path)
#     result = pipeline.call(contents)

#     File.open("out/#{path.split("/").pop.sub('.md', '.html')}", 'w') { |file| file.write(result[:output].to_s) }
#   end
# end

# test your out dir!
HTMLProofer.check_directory("docs").run