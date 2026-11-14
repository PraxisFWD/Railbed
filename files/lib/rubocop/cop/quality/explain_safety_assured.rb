# typed: strict
# frozen_string_literal: true

require "rubocop"
require "sorbet-runtime"

module RuboCop
  module Cop
    module Quality
      # Strong Migrations stops at operations it judges risky or cannot inspect. `safety_assured`
      # overrides that, so each use must say why the operation is safe, and must not hide a
      # change_table that add_column calls would let Strong Migrations check.
      class ExplainSafetyAssured < RuboCop::Cop::Base
        extend T::Sig

        MSG = "Explain in a comment directly above `safety_assured` why the operation is safe."
        MSG_CHANGE_TABLE = "Use `add_column` instead of `change_table` so Strong Migrations can check each column, " \
          "rather than wrapping it in `safety_assured`."

        sig { params(node: RuboCop::AST::BlockNode).void }
        def on_block(node)
          return unless safety_assured?(node) && checked_migration?

          add_offense(node.send_node) unless explained?(node)
          node.each_descendant(:send) do |call|
            add_offense(call, message: MSG_CHANGE_TABLE) if call.receiver.nil? && call.method?(:change_table)
          end
        end

        private

        sig { params(node: RuboCop::AST::BlockNode).returns(T::Boolean) }
        def safety_assured?(node)
          node.send_node.receiver.nil? && node.method?(:safety_assured)
        end

        sig { params(node: RuboCop::AST::BlockNode).returns(T::Boolean) }
        def explained?(node)
          processed_source.comments.any? { |comment| comment.loc.line == node.first_line - 1 }
        end

        sig { returns(T::Boolean) }
        def checked_migration?
          version = File.basename(processed_source.file_path.to_s)[/\A\d+/]
          version.nil? || version.to_i > cop_config.fetch("StartAfter", 0).to_i
        end
      end
    end
  end
end
