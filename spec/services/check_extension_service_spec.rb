RSpec.describe CheckExtensionService do
    describe '#call' do
        it 'should return xml for .resx files' do
            expect(CheckExtensionService.call('resx')).to eq 'xml'
        end

        it 'should return extension for other files' do
            expect(CheckExtensionService.call('yml')).to eq 'yml'
        end
    end
end