require 'lib/stnz_settings'

describe StnzSettings do
  it 'sets a key and value and returns the value' do
    StnzSettings.set(:tree, 'eucalytpus').should == 'eucalytpus'
  end

  it 'returns a value for a key' do
    StnzSettings.set(:tree, 'eucalytpus')
    StnzSettings.get(:tree).should == 'eucalytpus'
  end
end
