require 'rsolr'

class SolrService
  PER_PAGE = 10

  attr_reader :search_result

  def initialize
    @solr = RSolr.connect(url: "http://localhost:8080/solr/#{Rails.env}")
  end

  def add(document)
    @solr.add(document)
    @solr.commit
  end

  def delete(id)
    @solr.delete_by_id(id)
    @solr.commit
  end

  def raw_search(query: '*:*', page: 1)
    response = @solr.paginate page, 10, 'select', params: {q: query}
  end

  def search_events(text, page: 1)
    response = @solr.paginate page, 10, 'select', params: {q: "ctext:\"#{text}\""}
    @search_result = response['response']['docs'].map {|doc| doc['id']}
  end

  def delete_index
    @solr.delete_by_query '*:*'
  end

  module MongoidHooks
    def self.included(base)
      base.class_eval do
        def self.solr
          @solr ||= SolrService.new
        end    
      end

      base.send(:after_create) do |document|
        base.solr.add(document.solr_index_data)
      end

      base.send(:after_destroy) do |document|
        base.solr.delete(document.id.to_s)
      end

    end
  end
end
