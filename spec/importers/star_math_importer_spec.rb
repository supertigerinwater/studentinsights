require 'rails_helper'

RSpec.describe StarMathImporter do
  describe '#import_row' do
    context 'math file' do
      let(:file) { File.open("#{Rails.root}/spec/fixtures/fake_star_math.csv") }
      let(:transformer) { StarMathCsvTransformer.new }
      let(:csv) { transformer.transform(file) }
      let(:math_importer) { StarMathImporter.new }
      context 'with good data' do
        it 'creates a new assessment' do
          expect { math_importer.import(csv) }.to change { Assessment.count }.by 1
        end
        it 'creates a new STAR assessment' do
          math_importer.import(csv)
          assessment_family = Assessment.last.assessment_family
          expect(assessment_family.name).to eq "STAR"
        end
        it 'creates a new math assessment' do
          math_importer.import(csv)
          assessment_subject = Assessment.last.assessment_subject
          expect(assessment_subject.name).to eq "Math"
        end
        it 'sets math percentile rank correctly' do
          math_importer.import(csv)
          expect(Assessment.last.percentile_rank).to eq 70
        end
        it 'sets date taken correctly' do
          math_importer.import(csv)
          expect(Assessment.last.date_taken).to eq Date.new(2015, 1, 21)
        end
        context 'existing student' do
          let!(:student) { FactoryGirl.create(:student_we_want_to_update) }
          it 'does not create a new student' do
            expect { math_importer.import(csv) }.to change(Student, :count).by 0
          end
        end
        context 'new student' do
          it 'creates a new student object' do
            expect { math_importer.import(csv) }.to change(Student, :count).by 1
          end
        end
      end
      context 'with bad data' do
        let(:file) { File.open("#{Rails.root}/spec/fixtures/bad_star_reading_data.csv") }
        let(:transformer) { StarMathCsvTransformer.new }
        let(:csv) { transformer.transform(file) }
        let(:math_importer) { StarMathImporter.new }
        it 'raises an error' do
          expect { math_importer.import(csv) }.to raise_error NoMethodError
        end
      end
    end
  end
end
