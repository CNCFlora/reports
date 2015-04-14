require_relative File.expand_path('src/lib/dao/report')

class EcologyDAO < ReportDAO
    attr_accessor :data, :hash_fields

    def initialize(rows_of_document=nil)
        super(rows_of_document)
        @data = []
        @metadata_types = ["profile"]
        @hash_fields = {
            :id => "",
            :family => "",
            :scientificNameWithoutAuthorship => "",
            :lifeform => "", 
            :fenology  => "", 
            :luminosity => "",
            :substratum => "",
            :longevity => "", 
            :resprout => ""
        }
    end



    def generate_data(types=@metadata_types)

        set_docs_by_metadata_types
        @docs_by_metadata_types[@metadata_types[0]].each{ |profile|

            doc = profile["doc"]
            if doc["ecology"] && doc["ecology"].is_a?(Hash)

                family = ""
                scientificName = ""

                taxon = doc["taxon"] if doc["taxon"]
                family = taxon["family"] if taxon["family"] 
                scientificName = taxon["scientificNameWithoutAuthorship"] if taxon["scientificNameWithoutAuthorship"]

                lifeForm = ""
                fenology = ""
                luminosity = "" 
                substratum = "" 
                longevity = ""
                resprout = "" 

                ecology = doc["ecology"] 
                lifeForm = ecology["lifeForm"] if ecology["lifeForm"]
                fenology = ecology["fenology"] if ecology["fenology"]
                luminosity = ecology["luminosity"] if ecology["luminosity"]
                substratum = ecology["substratum"] if ecology["substratum"]
                longevity = ecology["longevity"] if ecology["longevity"]
                resprout = ecology["resprout"] if ecology["resprout"]

                @hash_fields[:id] = doc["_id"]
                @hash_fields[:family] = family 
                @hash_fields[:scientificNameWithoutAuthorship] = scientificName 
                @hash_fields[:lifeForm] = lifeForm
                @hash_fields[:fenology] = fenology
                @hash_fields[:luminosity] = luminosity
                @hash_fields[:substratum] = substratum
                @hash_fields[:longevity] = longevity
                @hash_fields[:resprout] = resprout
                _hash_fields = @hash_fields.clone
                @data.push(_hash_fields) 
                clean_hash_fields
            end

        }

        @data.sort_by!{|h| 
            [ 
                h[:family],
                h[:scientificNameWithoutAuthorship],
                h[:lifeForm],
                h[:fenology],
                h[:luminosity],
                h[:substratum],
                h[:longevity],
                h[:resprout]
            ]
        }        
    end

    def clean_hash_fields
        @hash_fields.each{ |k,v|
            @hash_fields[k] = ""
        }        
    end

end