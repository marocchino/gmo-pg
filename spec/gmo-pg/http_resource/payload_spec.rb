require 'spec_helper'

RSpec.describe GMO::PG::Payload do
  class ClassInheritedPayload < GMO::PG::Payload
    bind_attribute :GMOParam1, :ruby_attr_1
    bind_attribute :GMOParam2, :ruby_attr_2
    bind_attribute :IntegerParam,    :integer_attr,     typecast: :integer
    bind_attribute :EpochTimeParam,  :epoch_time_attr,  typecast: :epoch_time
    bind_attribute :CustomTypeParam, :custom_type_attr, typecast: {
      to_attribute: -> (value) { "called #to_attribute with #{value}" },
      to_payload:   -> (value) { "called #to_payload with #{value}" },
    }
  end

  describe '::encode' do
    it 'returns URI encoded string' do
      result = GMO::PG::Payload.encode(Param1: 'value1', Param2: 'value2')
      expect(result).to eq 'Param1=value1&Param2=value2'
    end
  end

  describe '::decode' do
    it 'returns URI decoded Hash' do
      result = GMO::PG::Payload.decode('Param1=value1&Param2=value2')
      expect(result).to eq 'Param1' => 'value1', 'Param2' => 'value2'
    end
  end

  describe 'attribute accessors' do
    it 'assigns and returns attribute value' do
      payload = ClassInheritedPayload.new
      payload[:GMOParam1]    = 'value1'; expect(payload.ruby_attr_1).to eq 'value1'
      payload[:ruby_attr_1]  = 'value2'; expect(payload.ruby_attr_1).to eq 'value2'
      payload['GMOParam1']   = 'value3'; expect(payload.ruby_attr_1).to eq 'value3'
      payload['ruby_attr_1'] = 'value4'; expect(payload.ruby_attr_1).to eq 'value4'

      payload.ruby_attr_1 = 'value5'; expect(payload[:GMOParam1]).to    eq 'value5'
      payload.ruby_attr_1 = 'value6'; expect(payload[:ruby_attr_1]).to  eq 'value6'
      payload.ruby_attr_1 = 'value7'; expect(payload['GMOParam1']).to   eq 'value7'
      payload.ruby_attr_1 = 'value8'; expect(payload['ruby_attr_1']).to eq 'value8'

      payload.ruby_attr_1 = 'value9'; expect(payload.ruby_attr_1).to eq 'value9'
    end
  end

  describe '#payload' do
    it 'returns frozen hash' do
      time = Time.new(2017, 1, 2, 12, 34, 56)

      payload = ClassInheritedPayload.new(
        ruby_attr_1:      'value1',
        GMOParam2:        'value2',
        integer_attr:     123.456,
        epoch_time_attr:  time.to_i.to_s,
        custom_type_attr: '123',
        UndefParam:       'value3',
      )
      expect(payload.payload).to eq(
        GMOParam1:       'value1',
        GMOParam2:       'value2',
        IntegerParam:    '123',
        EpochTimeParam:  time.localtime('+09:00').strftime('%Y%m%d%H%M%S'),
        CustomTypeParam: 'called #to_payload with 123',
        UndefParam:      'value3',
      )
    end
  end

  describe '#to_hash' do
    it 'returns hash' do
      time = Time.new(2017, 1, 2, 12, 34, 56)

      payload = ClassInheritedPayload.new(
        ruby_attr_1:      'value1',
        GMOParam2:        'value2',
        integer_attr:     123.456,
        epoch_time_attr:  time.to_i.to_s,
        custom_type_attr: '123',
        UndefParam:       'value3',
      )
      expect(payload.to_hash).to eq(
        ruby_attr_1:      'value1',
        ruby_attr_2:      'value2',
        integer_attr:     123,
        epoch_time_attr:  time.to_i,
        custom_type_attr: 'called #to_attribute with 123',
        UndefParam:       'value3',
      )
    end
  end

  describe '#inspect' do
    it 'returns described string' do
      payload = ClassInheritedPayload.new(
        ruby_attr_1: 'value1',
        UndefParam:  'value2',
      )
      expect(payload.inspect).to match /#<ClassInheritedPayload:\w+ "GMOParam1=value1&UndefParam=value2">/
    end
  end
end
