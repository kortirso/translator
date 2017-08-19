module Checks
    # Split sentences, remove untranslated things
    class SentenceService
        REGEXP_YML_TAGS = /<.+?>/
        REGEXP_XML_VARIABLES = /<xliff:g.+?xliff:g>/

        attr_reader :extension, :sentence_checker

        def initialize(extension)
            @extension = extension
            @sentence_checker = "Checks::Sentences::#{extension.capitalize}".constantize.new
        end

        def call(value, blocks = [], rebuilded_sentence = [])
            if value.is_a?(String)
                sentence_splitted_by_dot(value).each do |sentence|
                    check = sentence_checker.call(sentence)
                    rebuilded_sentence.push check[:sentence]
                    blocks += check[:blocks_for_translate]
                end
                rebuilded_sentence = rebuilded_sentence.join('.')
                rebuilded_sentence += '.' if value[-1] == '.'
            else
                rebuilded_sentence = value
            end
            {
                sentence: rebuilded_sentence,
                blocks_for_translate: blocks
            }
        end

        private

        def sentence_splitted_by_dot(value)
            case extension
                when :yml then yml_splitting(value)
                when :xml then xml_splitting(value)
                else value.split('.')
            end
        end

        def yml_splitting(value)
            # replace dots in tags
            value.scan(REGEXP_YML_TAGS).each do |tag|
                value.gsub!(tag, tag.gsub('.', '_##_'))
            end

            # split value for sentences and put dots in sentence
            value.split('.').map! { |sent| sent.gsub('_##_', '.') }
        end

        def xml_splitting(value)
            # replace dots in variables
            value.scan(REGEXP_XML_VARIABLES).each do |tag|
                value.gsub!(tag, tag.gsub('.', '_##_'))
            end

            # split value for sentences and put dots in sentence
            value.split('.').map! { |sent| sent.gsub('_##_', '.') }
        end
    end
end
