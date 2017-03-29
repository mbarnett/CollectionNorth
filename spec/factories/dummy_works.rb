class DummyWork < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  #include Sufia::WorkBehavior

  self.human_readable_type = 'Work'
  self.indexer = class DummyIndexer < CurationConcerns::WorkIndexer
                  def generate_solr_document
                    super.tap do |solr_doc|
                      solr_doc[Solrizer.solr_name('member_of_paths', :descendent_path)] = object.member_of_paths
                    end
                  end
                end


  class MyTerms < ::RDF::Vocabulary("http://terms.library.ualberta.ca/id/")
    term :foo
  end

  property :member_of_paths, predicate: MyTerms.foo, multiple: true do |index|
    index.as :descendent_path
  end
end

FactoryGirl.define do
  factory :work, class: DummyWork do
    title ['A Work']
  end
end
