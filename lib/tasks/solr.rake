namespace :solr do
  desc 'Drops index and recreates it again'
  #TODO rework to use Game
  task reindex: :environment do
    Game.solr.delete_index
    Game.each do |g|
      Game.solr.add(g.solr_index_data)
    end
  end
end
