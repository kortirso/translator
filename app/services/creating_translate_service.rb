class CreatingTranslateService
    def self.create(params)
        word_1 = Word.create text: params[:base], locale: Locale.find_by(code: params[:task][:from])
        word_2 = Word.create text: params[:result], locale: Locale.find_by(code: params[:task][:to])
        translation = Translation.create base: word_1, result: word_2
        translation.positions.create task: params[:task]
    end
end