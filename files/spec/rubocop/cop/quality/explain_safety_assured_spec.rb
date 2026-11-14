# frozen_string_literal: true

require "rubocop"
require_relative "../../../../lib/rubocop/cop/quality/explain_safety_assured"

RSpec.describe RuboCop::Cop::Quality::ExplainSafetyAssured do
  subject(:messages) { investigate(source, path).map(&:message) }

  let(:config) do
    RuboCop::Config.new("Quality/ExplainSafetyAssured" => { "Enabled" => true, "StartAfter" => 20261114130001 })
  end
  let(:cop) { described_class.new(config) }
  let(:path) { "db/migrate/20261115000000_probe.rb" }

  context "with an explained safety_assured block" do
    let(:source) { <<~RUBY }
      # The table holds a few hundred rows, so the backfill finishes well inside the lock timeout.
      safety_assured do
        execute "UPDATE companies SET lifecycle = 'active'"
      end
    RUBY

    it "does not report an offense" do
      expect(messages).to be_empty
    end
  end

  context "with an unexplained safety_assured block" do
    let(:source) { <<~RUBY }
      safety_assured do
        execute "UPDATE companies SET lifecycle = 'active'"
      end
    RUBY

    it "asks for an explanation" do
      expect(messages).to contain_exactly(described_class::MSG)
    end
  end

  context "with an unexplained safety_assured brace block" do
    let(:source) { "safety_assured { execute \"UPDATE companies SET lifecycle = 'active'\" }" }

    it "asks for an explanation" do
      expect(messages).to contain_exactly(described_class::MSG)
    end
  end

  context "when a blank line separates the comment from safety_assured" do
    let(:source) { <<~RUBY }
      # The table holds a few hundred rows.

      safety_assured do
        execute "UPDATE companies SET lifecycle = 'active'"
      end
    RUBY

    it "asks for an explanation" do
      expect(messages).to contain_exactly(described_class::MSG)
    end
  end

  context "with change_table inside an explained safety_assured block" do
    let(:source) { <<~RUBY }
      # Two nullable columns without defaults.
      safety_assured do
        change_table :opportunities, bulk: true do |t|
          t.string :loss_reason
        end
      end
    RUBY

    it "asks for add_column instead" do
      expect(messages).to contain_exactly(described_class::MSG_CHANGE_TABLE)
    end
  end

  context "with change_table outside safety_assured" do
    let(:source) { <<~RUBY }
      change_table :opportunities, bulk: true do |t|
        t.string :loss_reason
      end
    RUBY

    it "leaves the check to Strong Migrations" do
      expect(messages).to be_empty
    end
  end

  context "with a migration at the StartAfter version" do
    let(:path) { "db/migrate/20261114130001_validate_opportunity_loss_reason.rb" }
    let(:source) { "safety_assured { change_table(:opportunities) { |t| t.text :loss_note } }" }

    it "does not report an offense" do
      expect(messages).to be_empty
    end
  end

  context "with a migration just after the StartAfter version" do
    let(:path) { "db/migrate/20261114130002_probe.rb" }
    let(:source) { "safety_assured { execute 'SELECT 1' }" }

    it "asks for an explanation" do
      expect(messages).to contain_exactly(described_class::MSG)
    end
  end

  def investigate(source, path)
    processed_source = RuboCop::ProcessedSource.new(source, RuboCop::TargetRuby::DEFAULT_VERSION, path)
    RuboCop::Cop::Team.new([ cop ], config, raise_error: true).investigate(processed_source).offenses
  end
end
