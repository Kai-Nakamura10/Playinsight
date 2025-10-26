class AddUniqueIndexToTacticsSlug < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    # Enforce DB-level uniqueness for non-NULL slugs.
    # - Uses a partial unique index so existing NULLs (if any) do not conflict.
    # - Concurrent creation avoids long table locks on PostgreSQL.
    add_index :tactics,
              :slug,
              unique: true,
              where: "slug IS NOT NULL",
              algorithm: :concurrently,
              name: "index_tactics_on_slug_unique"
  end
end
