namespace :solr do
  desc 'Drops index and recreates it again'
  task reindex: :environment do
    Game.solr.delete_index
    Game.each do |g|
      Game.solr.add(g.solr_index_data)
    end

    User.each do |u|
      User.solr.add(u.solr_index_data)
    end
  end
end
