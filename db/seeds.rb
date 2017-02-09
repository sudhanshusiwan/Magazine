# create tag with string India
india_tag = Tag.create!({tag_string: 'India'})

# subtags Chennai and New Delhi under India tag
chennai_sub_tag = india_tag.sub_tags.create( sub_tag_string: 'Chennai' )
delhi_sub_tag = india_tag.sub_tags.create( sub_tag_string: 'New Delhi' )

# create tag with string Germany
germany_tag = Tag.create!({tag_string: 'Germany'})

# create subtags Berlin adn Munich in Germany tag
berlin_sub_tag = germany_tag.sub_tags.create( sub_tag_string: 'Berlin' )
munich_sub_tag = germany_tag.sub_tags.create( sub_tag_string: 'Munich' )

# create user mertcan
mertcan = User.create!({name: 'Mertcan', email: 'mertcan@gmail.com', password: 'password',
                      reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil,
                      sign_in_count: 3, current_sign_in_at: '2017-02-09 00:13:38', last_sign_in_at: '2017-02-08 22:23:24',
                      current_sign_in_ip: '127.0.0.1', last_sign_in_ip: '127.0.0.1' })

# create user sudhanshu
sudhanshu = User.create!({name: 'Sudhanshu', email: 'sudhanshu@gmail.com', password: 'password',
                      reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil,
                      sign_in_count: 3, current_sign_in_at: '2017-02-09 00:13:38', last_sign_in_at: '2017-02-08 22:23:24',
                      current_sign_in_ip: '127.0.0.1', last_sign_in_ip: '127.0.0.1' })

# Create Article about Berlin
berlin_article = mertcan.articles.create!( { name: 'Introduction of Berlin',
                            description: "Berlin, Germany’s capital, dates to the 13th century. Reminders of the city's turbulent 20th-century history include its Holocaust memorial and the Berlin Wall's graffitied remains. Divided during the Cold War, its 18th-century Brandenburg Gate has become a symbol of reunification. The city's also known for its art scene and modern landmarks like the gold-colored, swoop-roofed Berliner Philharmonie, built in 1963."} )

# Create article about Munich
munich_article = mertcan.articles.create!( { name: 'Introduction of Munich',
                            description: 'Munich, Bavaria’s capital, is home to centuries-old buildings and numerous museums. The city is known for its annual Oktoberfest celebration and its beer halls, including the famed Hofbräuhaus, founded in 1589. In the Altstadt (Old Town), central Marienplatz square contains landmarks such as Neo-Gothic Neues Rathaus (town hall), with a popular glockenspiel show that chimes and reenacts stories from the 16th century.'} )

# add germany tag and berlin subtag to berlin article
berlin_article.tags << germany_tag
berlin_article.sub_tags << berlin_sub_tag

# add germany tag and munich subtag to munich article
munich_article.tags << germany_tag
munich_article.sub_tags << munich_sub_tag

# Create article about new delhi
delhi_article = sudhanshu.articles.create!( { name: 'Introduction of New Delhi',
                            description: 'Delhi, India’s capital territory, is a massive metropolitan area in the country’s north. In Old Delhi, a neighborhood dating to the 1600s, stands the imposing Mughal-era Red Fort, a symbol of India, and the sprawling Jama Masjid mosque, whose courtyard accommodates 25,000 people. Nearby is Chandni Chowk, a vibrant bazaar filled with food carts, sweets shops and spice stalls.'} )

# create article about chennai
chennai_article = sudhanshu.articles.create!( { name: 'Introduction of Chennai',
                            description: 'Chennai, on the Bay of Bengal in eastern India, is the capital of the state of Tamil Nadu. The city is home to Fort St. George, built in 1644 and now a museum showcasing the city’s roots as a British military garrison and East India Company trading outpost, when it was called Madras. Religious sites include Kapaleeshwarar Temple, adorned with carved and painted gods, and St. Mary’s, a 17th-century Anglican church.'} )

# add india tag and new delhi sub_tag to delhi article
delhi_article.tags << india_tag
delhi_article.sub_tags << delhi_sub_tag

# add india tag and chennai sub_tag to chennai article
chennai_article.tags << india_tag
chennai_article.sub_tags << chennai_sub_tag