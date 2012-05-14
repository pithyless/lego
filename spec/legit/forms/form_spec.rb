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

  context 'validate_before_fields' do

    it 'does not validate fields if before_fields invalid' do
      form = MyForm.new(name: 'foo', age: 0, tags: 'one, two')
      def form.validate_before_fields
        return {last_name: 'Kennedy'}, {last_name: ['invalid']}
      end

      form.raw_data.should == { name: 'foo', age: 0, tags: 'one, two' }
      form.should_not be_valid
      form.cleaned_data.should == {}
      form.errors.should == { last_name: ['invalid'] }
    end

    it 'validates fields if before_fields valid' do
      form = MyForm.new(name: 'foo', age: 0, tags: 'one, two')
      def form.validate_before_fields
        return {last_name: 'Kennedy'}, {}
      end

      form.raw_data.should == { name: 'foo', age: 0, tags: 'one, two' }
      form.should_not be_valid
      form.cleaned_data.should == {}
      form.errors.should == { age: ['must be at least 1'] }
    end

    it 'merges cleaned_data if everything valid' do
      form = MyForm.new(name: 'foo', age: 10, tags: 'one, two')
      def form.validate_before_fields
        return {last_name: 'Kennedy'}, {}
      end

      form.raw_data.should == { name: 'foo', age: 10, tags: 'one, two' }
      form.should be_valid
      form.cleaned_data.should == { name: 'foo', age: 10, tags: %w{one two}, last_name: 'Kennedy'}
      form.errors.should == {}
    end

  end


  context 'validate_after_fields' do

    it 'does not validate after_fields if fields invalid' do
      form = MyForm.new(name: 'foo', age: 0, tags: 'one, two')
      def form.validate_after_fields
        return {}, {city: ['missing']}
      end

      form.raw_data.should == { name: 'foo', age: 0, tags: 'one, two' }
      form.should_not be_valid
      form.cleaned_data.should == {}
      form.errors.should == { age: ['must be at least 1'] }
    end

    it 'validates after_fields if fields valid' do
      form = MyForm.new(name: 'foo', age: 10, tags: 'one, two')
      def form.validate_after_fields
        return {}, {city: ['missing']}
      end

      form.raw_data.should == { name: 'foo', age: 10, tags: 'one, two' }
      form.should_not be_valid
      form.cleaned_data.should == {}
      form.errors.should == { city: ['missing'] }
    end

    it 'merges cleaned_data if everything valid' do
      form = MyForm.new(name: 'foo', age: 10, tags: 'one, two')
      def form.validate_before_fields
        return {city: 'Chicago'}, {}
      end

      form.raw_data.should == { name: 'foo', age: 10, tags: 'one, two' }
      form.should be_valid
      form.cleaned_data.should == { name: 'foo', age: 10, tags: %w{one two}, city: 'Chicago'}
      form.errors.should == {}
    end

  end


end
