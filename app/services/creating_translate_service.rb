class CreatingTranslateService
    def self.create(params)
        word_1 = Word.create text: params[:base][:word], locale: params[:base][:locale]
        word_2 = Word.create text: params[:result][:word], locale: params[:result][:locale]
        Translation.create base: word_1, result: word_2
    end
end