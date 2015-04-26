xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
  # create the urlset
  xml.urlset :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
    # photo pages
    TextPage.all.each do |page|
      xml.url do # create the url entry, with the specified location and date
        xml.loc root_url + page.url
        xml.lastmod page.updated_at.strftime('%Y-%m-%d')
      end
    end

    Location.all.each do |b|
      xml.url do
        xml.loc location_url(b)
        xml.lastmod b.updated_at.strftime('%Y-%m-%d')
      end
    end

    Restaurant.all.each do |b|
      xml.url do
        xml.loc restaurant_url(b)
        xml.lastmod b.updated_at.strftime('%Y-%m-%d')
      end
    end

  end
