# frozen_string_literal: true

require_relative 'periods_chain'

RSpec.describe PeriodsChain do
  describe 'valid?' do
    it 'should return true' do
      test = PeriodsChain.new('16.07.2023', ["2023", "2024", "2025"])
      expect(test.valid?).to eq(true)

      test = PeriodsChain.new('31.01.2023', ["2023M1", "2023M2", "2023M3"])
      expect(test.valid?).to eq(true)
      
      test = PeriodsChain.new('04.06.1976', ["1976M6D4", "1976M6D5", "1976M6D6"])
      expect(test.valid?).to eq(true)

      test = PeriodsChain.new('30.01.2023', ["2023M1", "2023M2", "2023M3D30"])
      expect(test.valid?).to eq(true)

      test = PeriodsChain.new('30.01.2020', ["2020M1", "2020", "2021", "2022", "2023", "2024M2", "2024M3D30"])
      expect(test.valid?).to eq(true)

      test = PeriodsChain.new('30.01.2023', ["2023M1D30", "2023M1", "2023M2", "2023", "2024M3", "2024M4D30", "2024M5"])
      expect(test.valid?).to eq(true)
    end

    it 'should return false' do
      test = PeriodsChain.new('24.04.2023', ["2023", "2025", "2026"])
      expect(test.valid?).to eq(false)

      test = PeriodsChain.new('10.01.2023', ["2023M1", "2023M3", "2023M4"])
      expect(test.valid?).to eq(false)

      test = PeriodsChain.new('02.05.2023', ["2023M5D2", "2023M5D3", "2023M5D5"])
      expect(test.valid?).to eq(false)

      test = PeriodsChain.new('31.01.2023', ["2023M1", "2023M2", "2023M3D30"])
      expect(test.valid?).to eq(false)

      test = PeriodsChain.new('30.01.2020', ["2020M1", "2020", "2021", "2022", "2023", "2024M2", "2024M3D29"])
      expect(test.valid?).to eq(false)
    end
  end
end