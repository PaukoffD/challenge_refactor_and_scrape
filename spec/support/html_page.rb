def html_page(name)
  File.read fixture_path + "/#{name}.html"
end
