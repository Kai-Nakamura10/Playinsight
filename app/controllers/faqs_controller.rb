class FaqsController < ApplicationController
  def show
    category_case = <<~SQL.squish
      CASE category
        WHEN '試合の流れ・時間編' THEN 1
        WHEN 'チーム・選手編'     THEN 2
        WHEN '会場・応援編'       THEN 3
        WHEN 'その他'             THEN 4
        ELSE 99
      END
    SQL

    @faqs = Faq
              .includes(:faqs_answers)
              .order(Arel.sql(category_case), :order)
  end
end
