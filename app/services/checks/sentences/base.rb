module Checks
    module Sentences
        # common module for all checking sentences
        module Base
            REGEXP_YML_TAGS = /<.+?>/

            REGEXP_XML_VARIABLES = /<xliff:g.+?xliff:g>/
            REGEXP_YML_VARIABLES = /%{\w+?}/

            REGEXP_START_SPACES = /^[\s,:;|\'\"]*/
            REGEXP_TRAIL_SPACES = /[\s,:;|\'\"]*$/

            REGEXP_SPECIAL = /&[0-9a-zA-Z#]+?;/
        end
    end
end
