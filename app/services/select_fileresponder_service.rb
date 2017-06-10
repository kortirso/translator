# Returns fileresponder's class
class SelectFileresponderService
    def self.call(task)
        extension = task.file_name.split('.').last
        case extension
            when 'json', 'resx', 'strings', 'yml' then "Fileresponders::#{extension.capitalize}".constantize
            else task.failure(102)
        end
    end
end
