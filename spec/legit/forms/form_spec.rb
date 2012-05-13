require 'spec_helper'

class MyForm < Legit::Forms::Form
  def fields
    {
      name: Legit::Values::StringValue.new(strip: true, downcase: true),
      age: Legit::Values::IntegerValue.new(min: 1, max: 120),
      tags: Legit::Values::ArrayValue.new(split: ',',
              element: Legit::Values::StringValue.new(strip: true, downcase: true))
    }
  end
end


describe 'Form' do

  it 'is unbound without data' do
    form = MyForm.new
    form.raw_data.should == {}
    form.should_not be_valid
    form.cleaned_data.should == {}
    form.errors.should == {}
  end

  it 'has cleaned_data on success' do
    form = MyForm.new(name: 'FoO', age: 4, tags: 'one, TWO, thrEE')
    form.raw_data.should == { name: 'FoO', age: 4, tags: 'one, TWO, thrEE' }
    form.should be_valid
    form.cleaned_data.should == { name: 'foo', age: 4, tags: %w{one two three} }
    form.errors.should == {}
  end

  it 'highlights all errors' do
    form = MyForm.new(name: 'FoO', age: '0')
    form.raw_data.should == { name: 'FoO', age: '0' }
    form.should_not be_valid
    form.cleaned_data.should == {}
    form.errors.should == { age: ['must be at least 1'], tags: ['is required'] }
  end

end
