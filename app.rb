require 'zillabyte' 
require 'nokogiri'
require 'open-uri'
app = Zillabyte.app("document_extractor")


# This is a Zillabyte Open Dataset; Details at zillabyte.com/open-data 
stream = app.source("select * from web_deep")


# For each page in the web data, perform the following... 
stream = stream.each do |tuple|
  
  # Init 
  url = URI.parse(tuple[:url]) rescue next
  doc = Nokogiri::HTML(tuple[:html])
  
  # Extract all the links, see which ones are '.pdfs'
  doc.css('a').each do |link|
    
    href = link.attribute('href').to_s.downcase.gsub(' ','%20')
    if href.end_with?(".pdf")
      target_url = URI.join(url, href) rescue next
      
      # Emit back to the stream
      emit(
        :type => ".pdf", 
        :source_url => url.to_s, 
        :source_domain => url.host.to_s, 
        :target_url => target_url.to_s, 
        :target_domain => target_url.host
      )
    end
  end
    
end


# Finally, sink the data back to ZB for later download... 
stream = stream.sink do
  name "web_documents"
  column :type, :string
  column :source_url, :string
  column :source_domain, :string
  column :target_url, :string
  column :target_domain, :string
end
