def file_fixture(string)
  file = Tempfile.new('foo')
  file.write(string)
  file.rewind
  file.path
end
