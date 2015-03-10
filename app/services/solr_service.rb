require 'rsolr'
require 'moped'

class SolrService
  PER_PAGE = 1000

  attr_reader :search_result

  def initialize
    @solr = RSolr.connect(url: Rails.application.config.solr_url)
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
    response = @solr.paginate page, PER_PAGE, 'select', params: {q: query}
  end

  def search_games(text, page: 1)
    response = @solr.paginate page, PER_PAGE, 'select', params: {q: "ctext:\"#{text}\""}
    @search_result = response['response']['docs'].map {|doc| BSON::ObjectId.from_string(doc['id'])}
  end

  def search_users(text, page: 1)
    response = @solr.paginate page, PER_PAGE, 'select', params: {q: "usertext:\"#{text}\""}
    @search_result = response['response']['docs'].map {|doc| BSON::ObjectId.from_string(doc['id'])}
  end

  def delete_index
    @solr.delete_by_query '*:*'
  end

  # Included class must define #solr_index_data method used by Solr
  module MongoidHooks
    def self.included(base)
      base.class_eval do
        def self.solr
          @solr ||= SolrService.new
        end
      end

      base.send(:after_create) do |document|
        begin
          base.solr.add(document.solr_index_data)
        rescue => e
          Rails.logger.warn('=== Solr is down ===')
          Rails.logger.warn("Cannot add #{document.id}")
        end
      end

      base.send(:after_update) do |document|
        begin
          base.solr.delete(document.id.to_s)
          base.solr.add(document.solr_index_data)
        rescue => e
          Rails.logger.warn('=== Solr is down ===')
          Rails.logger.warn("Cannot add #{document.id}")
        end
      end

      base.send(:after_destroy) do |document|
        begin
          base.solr.delete(document.id.to_s)
        rescue => e
          Rails.logger.warn('=== Solr is down ===')
          Rails.logger.warn("Cannot add #{document.id}")
        end
      end
    end
  end
end
