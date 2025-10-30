class AdjustTacticsStepsStructure < ActiveRecord::Migration[8.0]
    def up
    change_column_default :tactics, :steps, from: nil, to: {}
    execute <<~SQL
      UPDATE tactics
      SET steps = jsonb_build_object('success_conditions', steps)
      WHERE steps IS NOT NULL AND jsonb_typeof(steps) = 'array'
    SQL
    execute <<~SQL
      UPDATE tactics
      SET steps = '{}'::jsonb
      WHERE steps IS NULL
    SQL
  end

  def down
    change_column_default :tactics, :steps, from: {}, to: nil
  end
end
