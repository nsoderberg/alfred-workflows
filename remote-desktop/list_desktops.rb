require './alfred_feedback.rb'
require 'sqlite3'
query = ''
if ARGV.length > 0
    query = ARGV[0].downcase
end
home = `echo $HOME`.chomp
feedback = Feedback.new
begin
    db = SQLite3::Database.open "/Users/niklas/Library/Containers/com.microsoft.rdc.macos/Data/Library/Application\ Support/com.microsoft.rdc.macos/com.microsoft.rdc.application-data.sqlite"
    stm = db.prepare "SELECT ZHOSTNAME FROM ZBOOKMARKENTITY WHERE ZHOSTNAME LIKE '%#{query}%'"
rs = stm.execute 
    
    found = $false
rs.each do |row|
        feedback.add_item({:title => row[0], :subtitle => "Open desktop"})
        found = $true
    end
    if found
        feedback.add_item({:title => 'No matching desktop found', :subtitle => "Can't open desktop", :arg => '##notfound##'})
    end
    
    ensure
        stm.close if stm
        db.close if db
end
puts feedback.to_xml
